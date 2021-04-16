import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/database/database.dart';
import 'package:graduation_project/model/Student.dart';
import 'package:graduation_project/model/lecture.dart';
import 'package:path/path.dart' as Path;
import 'package:image_picker/image_picker.dart';
import 'package:graduation_project/pages/all_lecturerers/all_lecturers.dart';
import 'package:graduation_project/pages/chat_page/chat_screen.dart';
import 'package:graduation_project/pages/lectureres_students_screen/lectureres_students.dart';
import 'package:graduation_project/pages/notification_screen/notification_page.dart';
import 'package:graduation_project/pages/search_students/search_students.dart';
import 'package:graduation_project/pages/sign_up_student_screen/sign_up_student.dart';
import 'package:graduation_project/provider/chat_provider.dart';
import 'package:graduation_project/provider/doctor_provider.dart';
import 'package:graduation_project/provider/lecture_provider.dart';
import 'package:graduation_project/provider/student_provider.dart';
import 'package:graduation_project/utilities/constants.dart';
import 'package:provider/provider.dart';

class ProfileStudentPage extends StatefulWidget {
  static String routeName = "/student_profile";
  @override
  _ProfileStudentPageState createState() => _ProfileStudentPageState();
}

class _ProfileStudentPageState extends State<ProfileStudentPage> {
  Student student;
  List<Lecture> lectures;
  DataBaseService _dataBaseService = DataBaseService();

  File _image;

  @override
  void initState() {
    super.initState();

    Provider.of<StudentProvider>(context, listen: false).getStudentInfo();
    student = Provider.of<StudentProvider>(context, listen: false).student;

    Provider.of<LectureProvider>(context, listen: false).getStudentLecturers();
    lectures = Provider.of<LectureProvider>(context, listen: false).lectures;

    Provider.of<DoctorProvider>(context, listen: false).getAllDoctors();

    Provider.of<StudentProvider>(context, listen: false).getAllStudents();

    Provider.of<ChatProvider>(context, listen: false).fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(student.name),
        centerTitle: true,
        backgroundColor: secondaryLight,
        iconTheme: IconThemeData(color: primaryDark),
        actions: [
          Badge(
            badgeContent: Text(lectures.length.toString()),
            position: BadgePosition.topEnd(top: 10, end: 10),
            animationType: BadgeAnimationType.scale,
            child: IconButton(
              icon: Icon(Icons.notifications),
              color: primaryDark,
              onPressed: () {
                Navigator.pushNamed(context, NotificationPage.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryLight),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/user.png',
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(student.name),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Contact Us'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Me'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: secondaryLight,
        child: Center(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Image.asset(
                  'assets/images/user.png',
                  width: 100,
                  height: 100,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  student.section + " , " + student.department,
                  style: TextStyle(color: primaryDark, fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  student.number,
                  style: TextStyle(fontSize: 18, color: primaryDark),
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, LecturersStudentsScreen.routeName);
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.timelapse,
                            size: 30,
                            color: primaryDark,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text('Today Lecturers',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SearchStudents.routeName);
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.people_alt,
                            size: 30,
                            color: primaryDark,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text('Search Students',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ChatScreen.routeName);
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.message_outlined,
                            size: 30,
                            color: primaryDark,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text('Public Chat',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AllDoctors.routeName);
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.people,
                            size: 30,
                            color: primaryDark,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text('All Lecturers',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<StudentProvider>(context, listen: false)
                            .signOut();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentSignUp()));
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.logout,
                            size: 30,
                            color: primaryDark,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'LogOut',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
