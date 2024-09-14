import cv2
import os
import time
from roboflow import Roboflow
import threading

rbfkey = "VPnji39f7Fj12PD9z35O"
rf = Roboflow(api_key=rbfkey)
project = rf.workspace().project("gn-detect")
model = project.version(2).model

# Initialize the webcam
cap = cv2.VideoCapture(1)


def process_image(image_path):
    # Save the frame as an image file
    img = cv2.imread(image_path, frame)
    print(f"Image saved as {image_path}")
    cv2.rectangle(img, (50,50),(200,200),(255,0,0),2)
    cv2.imshow('Image with Rectangle', img)
    
# Check if the webcam is opened correctly
if not cap.isOpened():
    print("Error: Could not open webcam.")
    exit()

frame_counter = 0

try:
    while True:
        ret, frame = cap.read()

        if not ret:
            print("Failed to capture image")
            break

        if frame_counter % 2 == 0:
            # Display the resulting frame
            cv2.imshow("Webcam Footage", frame)

            # Process image in a new thread
            image_path = "temp_image.jpg"
            #cv2.rectangle(cv2.imread("image_path"),20,20,(255,0,0),2)
            threading.Thread(target=process_image, args=(image_path,)).start()

        frame_counter += 1

        # Press 'q' to quit the webcam window
        if cv2.waitKey(1) & 0xFF == ord("q"):
            break

except KeyboardInterrupt:
    print("Stopped by user")

finally:
    # Release the webcam and close any OpenCV windows
    cap.release()
    cv2.destroyAllWindows()

