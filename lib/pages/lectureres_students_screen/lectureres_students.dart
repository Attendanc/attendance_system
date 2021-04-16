import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/database/database.dart';
import 'package:graduation_project/model/lecture.dart';
import 'package:graduation_project/pages/detection/detection_abscence_page.dart';
import 'package:graduation_project/pages/lectureres_students_screen/components/card_lecture_component.dart';
import 'package:graduation_project/pages/profile_screen/profile_student_page.dart';
import 'package:graduation_project/provider/lecture_provider.dart';
import 'package:graduation_project/provider/student_provider.dart';
import 'package:graduation_project/services/facenet.service.dart';
import 'package:graduation_project/services/ml_vision_service.dart';
import 'package:graduation_project/utilities/constants.dart';
import 'package:provider/provider.dart';

/**
 * created by shaimaa salama
 */

class LecturersStudentsScreen extends StatefulWidget {
  static String routeName = '/lectures';

  @override
  _LecturersStudentsScreenState createState() =>
      _LecturersStudentsScreenState();
}

class _LecturersStudentsScreenState extends State<LecturersStudentsScreen> {
  CameraDescription cameraDescription;
  List<Lecture> lectures = [];

  FaceNetService _faceNetService = FaceNetService();
  MLVisionService _mlVisionService = MLVisionService();
  DataBaseService _dataBaseService = DataBaseService();

  @override
  void initState() {
    Provider.of<StudentProvider>(context, listen: false).getStudentInfo();

    Provider.of<LectureProvider>(context, listen: false).getStudentLecturers();
    lectures = Provider.of<LectureProvider>(context, listen: false).lectures;

    _startUp();

    super.initState();
  }

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 16,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ProfileStudentPage.routeName);
                },
                child: Image.asset(
                  'assets/images/user.png',
                  width: 50,
                  height: 50,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Welcom Dr,',
                style: TextStyle(fontSize: 20, color: primaryDark),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Shaimaa',
                style: TextStyle(fontSize: 20, color: primaryDark),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'All Courses Today',
            style: TextStyle(fontSize: 25, color: primaryDark),
          ),
          SizedBox(
            height: 10,
          ),
          Consumer<LectureProvider>(
            builder: (context, lecData, child) {
              Widget content = Center(
                child: Text('No Lectures'),
              );
              if (lecData.lectures.length > 0) {
                print(lecData.lectures[1].name);
                content = Container(
                  margin: EdgeInsets.only(left: 16, right: 16),
                  child: GridView.count(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      children: List.generate(lecData.lectures.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetectionAbscence(
                                          lecture: lecData.lectures[index],
                                          cameraDescription: cameraDescription,
                                        )));
                          },
                          child: CardLecture(
                            lecName: lecData.lectures[index].name,
                            lecTime: lecData.lectures[index].time,
                          ),
                        );
                      })),
                );
              } else if (lecData.isLoading) {
                content = CircularProgressIndicator();
              }
              return RefreshIndicator(
                  onRefresh: lecData.getStudentLecturers, child: content);
            },
          )
        ],
      )),
    );
  }
  /*

   */
}
