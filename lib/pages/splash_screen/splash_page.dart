import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/database/database.dart';
import 'package:graduation_project/pages/intro_screen/intro_screen_component.dart';
import 'package:graduation_project/services/facenet.service.dart';
import 'package:graduation_project/services/ml_vision_service.dart';
import 'package:graduation_project/utilities/constants.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FaceNetService _faceNetService = FaceNetService();
  MLVisionService _mlVisionService = MLVisionService();
  DataBaseService _dataBaseService = DataBaseService();

  CameraDescription cameraDescription;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _startUp();
  }

  /// 2 loads the face net model
  _startUp() async {
    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );

    // start the services
    await _faceNetService.loadModel();
    await _dataBaseService.loadDB();
    _mlVisionService.initialize();

    sleep(Duration(seconds: 10));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => IntroScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          color: primaryLight,
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              Text(
                'Attendance System',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/student.png',
                width: 100,
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
