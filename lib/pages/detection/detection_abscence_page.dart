import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/database/database.dart';
import 'package:graduation_project/model/Student.dart';
import 'package:graduation_project/model/lecture.dart';
import 'package:graduation_project/pages/lectureres_students_screen/lectureres_students.dart';
import 'package:graduation_project/provider/lecture_provider.dart';
import 'package:graduation_project/provider/student_provider.dart';
import 'package:graduation_project/services/camera.service.dart';
import 'package:graduation_project/services/facenet.service.dart';
import 'package:graduation_project/services/ml_vision_service.dart';
import 'package:camera/camera.dart';
import 'package:graduation_project/utilities/FacePainter.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:math' as math;
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetectionAbscence extends StatefulWidget {
  final Lecture lecture;
  final CameraDescription cameraDescription;

  const DetectionAbscence({Key key, this.cameraDescription, this.lecture})
      : super(key: key);

  @override
  _DetectionAbscenceState createState() => _DetectionAbscenceState();
}

class _DetectionAbscenceState extends State<DetectionAbscence> {
  /// Service injection
  CameraService _cameraService = CameraService();
  MLVisionService _mlVisionService = MLVisionService();
  FaceNetService _faceNetService = FaceNetService();
  DataBaseService _dataBaseService = DataBaseService();

  Future _initializeControllerFuture;

  bool cameraInitializated = false;
  bool _detectingFaces = false;
  bool pictureTaked = false;

  // switchs when the user press the camera
  bool _saving = false;

  String imagePath;
  Size imageSize;
  Face faceDetected;
  SharedPreferences preferences;
  BuildContext context;

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
    await _faceNetService.loadModel();
    _mlVisionService.initialize();

    _frameFaces();
  }

  /// draws rectangles when detects faces
  _frameFaces() {
    imageSize = _cameraService.getImageSize();
    _cameraService.cameraController.startImageStream((image) async {
      preferences = await SharedPreferences.getInstance();

      if (_cameraService.cameraController != null) {
        // if its currently busy, avoids overprocessing
        if (_detectingFaces) return;

        _detectingFaces = true;

        try {
          List<Face> faces = await _mlVisionService.getFacesFromImage(image);

          if (faces != null) {
            if (faces.length > 0) {
              setState(() {
                faceDetected = faces[0];
              });

              if (_saving) {
                _faceNetService.setCurrentPrediction(image, faceDetected);
                var userId = _faceNetService.predict();

                print("saving camera userId is $userId");

                print(
                    "saving camera userId is ${preferences.getString('studentId')}");

                await Provider.of<StudentProvider>(context, listen: false)
                    .getStudentInfo();

                var student =
                    Provider.of<StudentProvider>(context, listen: false)
                        .student;

                await Provider.of<LectureProvider>(context, listen: false)
                    .storeGoneLectures(widget.lecture, student);

                Navigator.pop(context);

                if (userId == preferences.getString('studentId')) {}
                setState(() {
                  _saving = false;
                });
              }
            } else {
              setState(() {
                faceDetected = null;
              });
            }
          }
          _detectingFaces = false;
        } catch (e) {
          print("catch frame faces error is $e");
          _detectingFaces = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    Future<void> onShot() async {
      if (faceDetected == null) {
        showDialog(
            context: context,
            child: AlertDialog(
              content: Text('No face detected!'),
            ));
        return false;
      } else {
        imagePath =
            join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');

        setState(() {
          _saving = true;
        });

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
      floatingActionButton: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.check),
          backgroundColor: new Color(0xFFE57373),
          onPressed: () async {
            /// on shot action to take picture
            onShot();
          }),
    );
  }
}
