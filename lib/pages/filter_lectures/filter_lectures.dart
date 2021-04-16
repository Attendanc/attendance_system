import 'package:flutter/material.dart';
import 'package:graduation_project/model/lecture.dart';
import 'package:graduation_project/pages/filter_lectures/components/filter_list_item.dart';
import 'package:graduation_project/pages/students_screen/gone_students_screen.dart';
import 'package:graduation_project/provider/lecture_provider.dart';
import 'package:graduation_project/provider/student_provider.dart';
import 'package:provider/provider.dart';

class FilterLectures extends StatefulWidget {
  String section;
  String department;

  FilterLectures({this.section, this.department});

  @override
  _FilterLecturesState createState() => _FilterLecturesState();
}

class _FilterLecturesState extends State<FilterLectures> {
  List<Lecture> lectures;

  _start() async {
    await Provider.of<LectureProvider>(context, listen: false)
        .getFiteredLecturers(widget.section, widget.department);

    Provider.of<StudentProvider>(context, listen: false).getAllStudents();

    lectures =
        Provider.of<LectureProvider>(context, listen: false).filterLecture;
  }

  @override
  void initState() {
    _start();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          child: Consumer<LectureProvider>(
            builder: (context, lecData, child) {
              Widget content = Center(
                child: Text(
                  'No Lectures',
                  style: TextStyle(color: Colors.black),
                ),
              );
              if (lecData.filterLecture.length > 0) {
                content = ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: lecData.filterLecture.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FilterListItem(
                      lecture: lectures[index],
                    );
                  },
                );
              } else if (lecData.isLoading) {
                content = Center(child: CircularProgressIndicator());
              }
              return Container(child: content);
            },
          ),
        ));
  }
}
