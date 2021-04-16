import 'package:flutter/material.dart';
import 'package:graduation_project/model/lecture.dart';
import 'package:path/path.dart';

class NotificationListItem extends StatefulWidget {
  Lecture lecture;

  NotificationListItem({this.lecture});

  @override
  _NotificationListItemState createState() => _NotificationListItemState();
}

class _NotificationListItemState extends State<NotificationListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.blueGrey[100],
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/images/exam.png',
              height: 50,
              width: 50,
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
                child: Text(
              '${widget.lecture.name} will hold at ${widget.lecture.time}',
              style: TextStyle(fontSize: 15),
            )),
          ],
        ),
      ),
    );
  }
}
