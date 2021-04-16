import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/services/camera.service.dart';

class MLVisionService {
  // singleton boilerplate
  static final MLVisionService _cameraServiceService =
      MLVisionService._internal();

  factory MLVisionService() {
    return _cameraServiceService;
  }
  // singleton boilerplate
  MLVisionService._internal();

  // service injection
  CameraService _cameraService = CameraService();

  FaceDetector _faceDetector;
  FaceDetector get faceDetector => this._faceDetector;

  void initialize() {
    this._faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
      ),
    );
  }

  Future<List<Face>> getFacesFromImage(CameraImage image) async {
    /// preprocess the image  🧑🏻‍🔧
    FirebaseVisionImageMetadata _firebaseImageMetadata =
        FirebaseVisionImageMetadata(
      rotation: _cameraService.cameraRotation,
      rawFormat: image.format.raw,
      size: Size(image.width.toDouble(), image.height.toDouble()),
      planeData: image.planes.map(
        (Plane plane) {
          return FirebaseVisionImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );

    /// Transform the image input for the _faceDetector 🎯
    FirebaseVisionImage _firebaseVisionImage = FirebaseVisionImage.fromBytes(
        image.planes[0].bytes, _firebaseImageMetadata);

    /// proces the image and makes inference 🤖
    List<Face> faces =
        await this._faceDetector.processImage(_firebaseVisionImage);

    print(
        "faceDetector is ${this._faceDetector.options.mode.toString()}==========================");
    print("faces are ${faces.length.toString()}==========================");

    return faces;
  }
}
