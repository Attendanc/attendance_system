import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/database/database.dart';
import 'package:graduation_project/pages/lectureres_students_screen/lectureres_students.dart';
import 'package:graduation_project/provider/lecture_provider.dart';
import 'package:graduation_project/services/camera.service.dart';
import 'package:graduation_project/services/facenet.service.dart';
import 'package:graduation_project/services/ml_vision_service.dart';
import 'package:graduation_project/utilities/FacePainter.dart';
import 'package:graduation_project/utilities/constants.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:math' as math;
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetectionSignUpScreen extends StatefulWidget {
  static String routeName = "/detection";
  final CameraDescription cameraDescription;

  DetectionSignUpScreen({Key key, this.cameraDescription}) : super(key: key);

  @override
  _DetectionSignUpScreenState createState() => _DetectionSignUpScreenState();
}

class _DetectionSignUpScreenState extends State<DetectionSignUpScreen> {
  String imagePath;
  Face faceDetected;
  Size imageSize;

  bool _detectingFaces = false;
  bool pictureTaked = false;

  Future _initializeControllerFuture;
  bool cameraInitializated = false;

  // switchs when the user press the camera
  bool _saving = false;

  // service injection
  MLVisionService _mlVisionService = MLVisionService();
  CameraService _cameraService = CameraService();
  FaceNetService _faceNetService = FaceNetService();
  DataBaseService _dataBaseService = DataBaseService();

  @override
  void initState() {
    /// starts the camera & start framing faces
    _start();
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraService.dispose();
    super.dispose();
  }

  /// starts the camera & start framing faces
  _start() async {
    _initializeControllerFuture =
        _cameraService.startService(widget.cameraDescription);
    await _initializeControllerFuture;

    setState(() {
      cameraInitializated = true;
    });

    ///inintialize ml vision for detection
    await _dataBaseService.loadDB();
    _mlVisionService.initialize();

    _frameFaces();
  }

  /// handles the button pressed event
  Future<void> onShot() async {
    print('onShot performed');

    if (faceDetected == null) {
      return false;
    } else {
      imagePath =
          join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');

      _saving = true;

      await Future.delayed(Duration(milliseconds: 500));
      await _cameraService.cameraController.stopImageStream();
      await Future.delayed(Duration(milliseconds: 200));
      await _cameraService.takePicture(imagePath);

      setState(() {
        pictureTaked = true;
      });

      return true;
    }
  }

  /// draws rectangles when detects faces
  _frameFaces() {
    imageSize = _cameraService.getImageSize();
    _cameraService.cameraController.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        // if its currently busy, avoids overprocessing
        if (_detectingFaces) return;

        _detectingFaces = true;

        try {
          ///process image to convert it to face and frame this face
          List<Face> faces = await _mlVisionService.getFacesFromImage(image);

          if (faces.length > 0) {
            setState(() {
              faceDetected = faces[0];
            });

            /// happens when take image shot with camera , starting image predection
            if (_saving) {
              _faceNetService.setCurrentPrediction(image, faceDetected);
              List predictedData = _faceNetService.predictedData;

              /// creates a new user in the 'database'
              final SharedPreferences preferences =
                  await SharedPreferences.getInstance();

              if (preferences.getString('studentId') != null) {
                await _dataBaseService.saveData(
                    preferences.getString('studentId'), predictedData);
              }

              /// resets the face stored in the face net sevice
              this._faceNetService.setPredictedData(null);
              setState(() {
                _saving = false;
              });
            }
          } else {
            setState(() {
              faceDetected = null;
            });
          }
          _detectingFaces = false;
        } catch (e) {
          print(e);
          _detectingFaces = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LectureProvider>(context, listen: false).getStudentLecturers();

    final double mirror = math.pi;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (pictureTaked) {
              return Container(
                width: width,
                child: Transform(
                    alignment: Alignment.center,
                    child: Image.file(File(imagePath)),
                    transform: Matrix4.rotationY(mirror)),
              );
            } else {
              return Transform.scale(
                scale: 1.0,
                child: AspectRatio(
                  aspectRatio: MediaQuery.of(context).size.aspectRatio,
                  child: OverflowBox(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Container(
                        width: width,
                        height: width /
                            _cameraService.cameraController.value.aspectRatio,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            CameraPreview(_cameraService.cameraController),
                            CustomPaint(
                              painter: FacePainter(
                                  face: faceDetected, imageSize: imageSize),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new FloatingActionButton.extended(
          elevation: 2.0,
          label: Text('Complete SignUp', style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.check),
          backgroundColor: primaryDark,
          onPressed: () async {
            /// on shot action to take picture
            if (faceDetected != null) {
              onShot();
              Navigator.pushNamed(context, LecturersStudentsScreen.routeName);
            }
          }),
    );
  }
}
