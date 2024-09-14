from roboflow import Roboflow
rbfkey = "VPnji39f7Fj12PD9z35O"
rf = Roboflow(api_key=rbfkey)

project = rf.workspace().project("gn-detect")
model = project.version(2).model

# infer on a local image

predictions = model.predict("backend/temp_image_46.jpg", confidence=40, overlap=30).json()
print(predictions)

