import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/utilities/constants.dart';

class CardLecture extends StatefulWidget {
  String lecName;
  String lecDate;
  String lecTime;

  CardLecture({@required this.lecName, @required this.lecTime});

  @override
  _CardLectureState createState() => _CardLectureState();
}

class _CardLectureState extends State<CardLecture> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: secondary,
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
                widget.lecName,
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.lecTime,
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ));
  }
}
