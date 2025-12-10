import json
import socket
import time
import statistics

from typing import Optional, Sequence, Literal

import cv2

import mediapipe.python.solutions.hands as mp_hands
import mediapipe.python.solutions.drawing_utils as mp_drawing
import mediapipe.python.solutions.drawing_styles as mp_drawing_styles


def extract_hand_type_index(
    multi_handedness: Sequence,
    hand_type: Literal["left", "right"],
) -> int:
    """
    Extract the index of the hand with the specified type from the multi-handedness list

    Args:
        multi_handedness: List of hand classifications for each hand
        hand_type: The type of hand to extract the index for

    Returns:
        Index of the hand with the specified type in the multi-handedness list. Returns -1 if the hand type is not found
    """
    hand_classification = [hand.classification[0] for hand in multi_handedness]

    hands = filter(
        lambda x: x.label.lower() == hand_type and x.score > 0.5, hand_classification
    )
    hands = sorted(hands, key=lambda x: x.score, reverse=True)

    if len(hands) == 0:
        return -1

    return hand_classification.index(hands[0])


def extract_left_right_hand_coords(
    multi_hand_landmarks: Optional[Sequence],
    multi_handedness: Sequence,
) -> dict:
    """
    Extract the coordinates of the left and right hands from the multi-hand landmarks

    Args:
        multi_hand_landmarks: List of landmarks for each hand
        multi_handedness: List of hand classifications for each hand

    Returns:
        Dictionary containing the coordinates of the left and right hands
    """
    hand_coords = {
        "left": None,
        "right": None,
    }

    if multi_hand_landmarks is None:
        return hand_coords
    
    for hand_type in ["left", "right"]:
        hand_idx = extract_hand_type_index(multi_handedness, hand_type)

        if hand_idx == -1:
            continue

        hand_lms = multi_hand_landmarks[hand_idx]

        hand_coords[hand_type] = [
            [landmark.x, landmark.y, landmark.z] for landmark in hand_lms.landmark
        ]
    print(hand_coords)
    return hand_coords

# ---------------------------- NEW METRIC STORAGE ----------------------------
fps_start = time.time()
frame_count = 0
fps = 0  # FIXED BUG — ensure fps always exists

latency_list = []
jitter_list = []
tracking_success = 0
tracking_fail = 0

prev_landmarks = None

def run_hand_tracking_server(
    server_ip: str,
    server_port: int,
) -> None:
    """
    Run the hand tracking which sends the hand coordinates via UDP.
    
    Args:
        server_ip: The IP address of the server
        server_port: The port number of the server
    """

    global frame_count, fps_start, fps
    global latency_list, jitter_list
    global tracking_success, tracking_fail
    global prev_landmarks

    # Setup the UDP client for sending the hand coordinates
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    # Open the webcam video feed
    cap = cv2.VideoCapture(0)

    # Create the hand-tracking model
    with mp_hands.Hands(
        model_complexity=0,
        max_num_hands=1,
        min_detection_confidence=0.8,
        min_tracking_confidence=0.5,
    ) as hands:

        while cap.isOpened():

            start_time = time.time()
            
            # Get a frame from the webcam
            ret, frame = cap.read()
            if not ret:
                print("Error: failed to capture image")
                break

            # Check the frame for hands. Hnad-tracking requires RGB images, while OpenCV captures in BGR
            frame_small = cv2.resize(frame, (320, 240))
            frame_rgb = cv2.cvtColor(frame_small, cv2.COLOR_BGR2RGB)

            results = hands.process(frame_rgb)

            # Extract the hand coordinates from the results into a dictionary:
            # hand_coords = {"left": [[x, y, z], ...], "right": [[x, y, z], ...]}
            hand_coords = extract_left_right_hand_coords(
                results.multi_hand_landmarks,
                results.multi_handedness,
            )

            # ------------------- evaluation metrics -------------------
            # A. success rate
            if hand_coords["left"] or hand_coords["right"]:
                tracking_success += 1
            else:
                tracking_fail += 1

            # B. latency
            processing_latency = (time.time() - start_time) * 1000
            latency_list.append(processing_latency)

            # C. jitter
            if hand_coords["left"]:
                current = hand_coords["left"]

                if prev_landmarks:
                    diffs = [
                        abs(current[i][0] - prev_landmarks[i][0]) +
                        abs(current[i][1] - prev_landmarks[i][1])
                        for i in range(len(current))
                    ]
                    jitter_list.append(sum(diffs) / len(diffs))

                prev_landmarks = current

            # D. FPS
            frame_count += 1
            if time.time() - fps_start >= 1.0:
                fps = frame_count
                frame_count = 0
                fps_start = time.time()
                print(f"[FPS] {fps}")

            # Add a timestamp for latency calculation
            hand_coords["timestamp"] = time.time()

            hand_coords["evaluation"] = {
                "processing_ms": processing_latency,
                "fps": fps,
            }

            # Send the hand coordinates to the client
            encoded_coords = json.dumps(hand_coords)
            client_socket.sendto(encoded_coords.encode(), (server_ip, server_port))

            # Draw the hand landmarks on the frame
            if results.multi_hand_landmarks:
                for hand_landmarks in results.multi_hand_landmarks:
                    mp_drawing.draw_landmarks(
                        frame_small,
                        hand_landmarks,
                        mp_hands.HAND_CONNECTIONS,
                        landmark_drawing_spec=mp_drawing_styles.get_default_hand_landmarks_style(),
                        connection_drawing_spec=mp_drawing_styles.get_default_hand_connections_style(),
                    )

            display_frame = cv2.resize(frame_small, (640, 480))
            cv2.imshow("Hand Tracking", cv2.flip(display_frame, 1))
            if cv2.waitKey(1) & 0xFF == ord("q"):
                break

    # ------------------- final results -------------------
    print("\n=== UI EVALUATION RESULTS ===")
    print(f"Average Processing Latency: {statistics.mean(latency_list):.2f} ms")
    print(f"Min/Max Latency: {min(latency_list):.2f} - {max(latency_list):.2f} ms")
    print(f"Average Jitter: {statistics.mean(jitter_list):.4f}")
    print(f"Tracking Success Rate: {tracking_success / (tracking_success + tracking_fail):.2%}")

    cap.release()
    cv2.destroyAllWindows()


if __name__ == "__main__":
    import traceback
    try:
        run_hand_tracking_server(
            server_ip="127.0.0.1",
            server_port=4242,
        )
    except Exception as e:
        print("=== PYTHON CRASH ===")
        traceback.print_exc()
        input("Press ENTER to exit...")
