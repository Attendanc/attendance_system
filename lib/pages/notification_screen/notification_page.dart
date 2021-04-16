import 'package:flutter/material.dart';
import 'package:graduation_project/model/lecture.dart';
import 'package:graduation_project/provider/lecture_provider.dart';
import 'package:graduation_project/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'component/body.dart';

class NotificationPage extends StatefulWidget {
  static String routeName = "/notification";

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Lecture> lectures;

  @override
  void initState() {
    super.initState();

    Provider.of<LectureProvider>(context, listen: false).getStudentLecturers();
    lectures = Provider.of<LectureProvider>(context, listen: false).lectures;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryLight,
      ),
      backgroundColor: Colors.white,
      body: Body(),
    );
  }
}
