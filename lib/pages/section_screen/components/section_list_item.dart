import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/pages/add_lecture_screen/add_lecture.dart';
import 'package:graduation_project/pages/students_screen/gone_students_screen.dart';
import 'package:graduation_project/utilities/constants.dart';

class SectionListItem extends StatefulWidget {
  String sectionName;
  Color color;

  SectionListItem({@required this.sectionName, @required this.color});

  @override
  _SectionListItemState createState() => _SectionListItemState();
}

class _SectionListItemState extends State<SectionListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0))),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 10,
            ),
            Text(
              widget.sectionName.toString(),
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.account_circle_outlined,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
