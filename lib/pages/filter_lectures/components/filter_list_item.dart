import 'package:flutter/material.dart';
import 'package:graduation_project/model/lecture.dart';
import 'package:graduation_project/pages/students_screen/abs_student_screen.dart';
import 'package:graduation_project/pages/students_screen/gone_students_screen.dart';
import 'package:graduation_project/provider/lecture_provider.dart';
import 'package:graduation_project/utilities/constants.dart';
import 'package:provider/provider.dart';

class FilterListItem extends StatefulWidget {
  Lecture lecture;

  FilterListItem({this.lecture});

  @override
  _FilterListItemState createState() => _FilterListItemState();
}

class _FilterListItemState extends State<FilterListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: primaryDark,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: new Center(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Image.asset(
                'assets/images/exam.png',
                height: 50,
                width: 50,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.lecture.name,
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.lecture.time,
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: FlatButton(
                      color: Colors.green[900],
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GoneStudentsScreen(
                                      lecture: widget.lecture,
                                    )));

                        Provider.of<LectureProvider>(context, listen: false)
                            .getGoneLectures(widget.lecture);
                      },
                      child: Text('الطلاب الحاضرين'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: FlatButton(
                      color: Colors.red,
                      child: Text('الطلاب الغائبين'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AbsStudentScreen(
                                      lecture: widget.lecture,
                                    )));

                        Provider.of<LectureProvider>(context, listen: false)
                            .getGoneLectures(widget.lecture);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
