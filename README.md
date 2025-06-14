# Integrating Reality: Real-Time Hand Tracking for Interactive 3D Game Mechanics

A camera-based hand-tracking system that enhances immersion in 3D games by allowing the player’s real hand to interact with the virtual world as a dynamic platform or obstacle without any special hardware required.

## Introduction

Most platform games rely on traditional keyboard or controller inputs, which limit physical engagement and immersion. While technologies like VR and Kinect offer more immersive experiences, they often require expensive, specialized hardware and full-body tracking setups.

This project introduces a low-cost, software-only alternative: a real-time hand-tracking system that uses a standard webcam to control a virtual hand in a 3D game environment. The virtual hand can interact with in-game objects, activate buttons, and influence gameplay using natural gestures.

## Features

- 🖐️ Real-time hand tracking using [MediaPipe](https://github.com/google/mediapipe) and OpenCV (Python)
- 🔁 UDP socket communication between Python and the Godot engine
- 🧠 JSON-based data transmission of hand landmark coordinates
- 🕹️ Interactive 3D hand model rendered and rigged in [Godot Engine](https://godotengine.org/)
- ⚙️ Physics-enabled hand interactions with game elements
- 🔘 Functional in-game button activated by virtual hand

## Setup
- Python 3.11.5
- OpenCV 4.9.0
- Godot 4.4
- MediaPipe 0.10.14
- Webcam

## Instructions

1. Install dependencies (python/requirements.txt)
2. Run python/hand_detection.py
3. Make sure your webcam is on and your hand is visible.
4. Open Godot and open the project (godot/project.godot).
5. Follow the in-game tutorial for guidance.
6. Enjoy!
