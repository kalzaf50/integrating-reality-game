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

## Requirements
- Python 3.8+
- Godot 4.x
- Webcam
- pip (Python package manager)

## Instructions

1. run python/hand_detection.py
2. Make sure your webcam is on and your hand is visible.
3. Open Godot and open the project (godot/project.godot).
4. Follow the in-game tutorial for guidance.
5. Enjoy!
