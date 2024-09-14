import requests
from roboflow import Roboflow
import cv2
import threading
import os
import time

# Initialize Roboflow model for video detection
rbfkey = "VPnji39f7Fj12PD9z35O"
rf = Roboflow(api_key=rbfkey)
project = rf.workspace().project("gn-detect")
model = project.version(2).model
print("Roboflow Initialized")

# Base URL for FastAPI service
baseUrl = "http://127.0.0.1:8000"

# Global variables for object detection
gunDetected = False
pred_box = None


# Function to process image and check for object detection
def process_image(image_path, frame, room):
    global gunDetected, pred_box

    # Save the frame as an image file
    cv2.imwrite(image_path, frame)

    # Get prediction from Roboflow
    prediction = model.predict(image_path, confidence=40, overlap=30).json()
    os.remove(image_path)

    if prediction["predictions"]:
        for pred in prediction["predictions"]:
            if pred["class"] == "pistol":
                gunDetected = True
                send_video_incident_log(room)


# Function to send POST request to FastAPI for video incidents
def send_video_incident_log(room: str):
    try:
        url = baseUrl + "/video-incident-log/"
        data = {
            "room_number": room,
            "event_time": time.strftime("%H:%M:%S"),  # Current time
            "incident_source": "video",
        }
        response = requests.post(url, json=data)
        print(f"Video incident log sent: {response.json()}")
    except Exception as e:
        print(f"Failed to send video log: {e}")


# Initialize webcam and process frames
cap = cv2.VideoCapture(0)
frame_counter = 0
processing_thread = None
frame_skip = 5  # Skip frames for performance
room_number = "101"  # Example room number

try:
    while True:
        ret, frame = cap.read()
        if not ret:
            print("Failed to capture image")
            break

        if frame_counter % frame_skip == 0:
            if processing_thread is None or not processing_thread.is_alive():
                image_path = "temp_image.jpg"
                frame_copy = frame.copy()
                processing_thread = threading.Thread(
                    target=process_image, args=(image_path, frame_copy, room_number)
                )
                processing_thread.start()

        cv2.imshow("Webcam Footage", frame)
        frame_counter += 1

        if cv2.waitKey(1) & 0xFF == ord("q"):
            break

except KeyboardInterrupt:
    print("Stopped by user")

finally:
    cap.release()
    cv2.destroyAllWindows()
