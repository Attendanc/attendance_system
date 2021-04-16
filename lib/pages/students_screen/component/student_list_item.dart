import 'package:flutter/material.dart';
import 'package:graduation_project/model/Student.dart';
import 'package:graduation_project/utilities/constants.dart';

class StudentListItem extends StatefulWidget {
  Student student;
  int index;

  StudentListItem({this.student, this.index});

  @override
  _StudentListItemState createState() => _StudentListItemState();
}

class _StudentListItemState extends State<StudentListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.blueGrey[100],
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(widget.index.toString() + "  ",
                    style: TextStyle(color: primaryDark, fontSize: 18)),
                Text(widget.student.name,
                    style: TextStyle(color: primaryDark, fontSize: 18)),
              ],
            ),
            Text(
              widget.student.number,
              style: TextStyle(color: primaryDark, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
