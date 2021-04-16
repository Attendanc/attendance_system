import 'package:flutter/material.dart';
import 'package:graduation_project/model/Student.dart';
import 'package:graduation_project/model/lecture.dart';
import 'package:graduation_project/provider/lecture_provider.dart';
import 'package:graduation_project/utilities/constants.dart';
import 'package:provider/provider.dart';

import 'component/student_list_item.dart';

class GoneStudentsScreen extends StatefulWidget {
  static String routeName = "/students";

  Lecture lecture;

  GoneStudentsScreen({this.lecture});

  @override
  _GoneStudentsScreenState createState() => _GoneStudentsScreenState();
}

class _GoneStudentsScreenState extends State<GoneStudentsScreen> {
  List<Student> goneStudents = [];

  @override
  void initState() {
    Provider.of<LectureProvider>(context, listen: false)
        .getGoneLectures(widget.lecture);

    goneStudents =
        Provider.of<LectureProvider>(context, listen: false).goneStudents;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryLight,
      ),
      resizeToAvoidBottomInset: false,
      body: Consumer<LectureProvider>(
        builder: (context, lecData, child) {
          Widget content = Center(
            child: Text('No Students'),
          );
          if (lecData.goneStudents.length > 0) {
            content = ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: goneStudents.length,
              itemBuilder: (BuildContext context, int index) {
                return StudentListItem(
                  student: goneStudents[index],
                  index: index,
                );
              },
            );
          } else if (lecData.isLoading) {
            content = Center(child: CircularProgressIndicator());
          }
          return Container(
            child: content,
          );
        },
      ),
    );
  }
}
