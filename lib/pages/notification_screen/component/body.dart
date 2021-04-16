import 'package:flutter/material.dart';
import 'package:graduation_project/model/lecture.dart';
import 'package:graduation_project/pages/notification_screen/component/notification_list_item.dart';
import 'package:graduation_project/provider/lecture_provider.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Lecture> lectures;

  @override
  void initState() {
    super.initState();

    Provider.of<LectureProvider>(context, listen: false).getStudentLecturers();
    lectures = Provider.of<LectureProvider>(context, listen: false).lectures;
    print("lectures count is ${lectures.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LectureProvider>(
      builder: (context, lecData, child) {
        Widget content = Center(child: Text('No Notifications'));
        if (lectures.length > 0) {
          content = Center(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.all(5),
              alignment: Alignment.center,
              child: ListView.builder(
                  itemCount: lectures.length,
                  itemBuilder: (BuildContext context, index) {
                    return NotificationListItem(
                        lecture: lecData.lectures[index]);
                  }),
            ),
          );
        } else if (lecData.isLoading) {
          content = Center(
            child: Container(
                color: Colors.white, child: CircularProgressIndicator()),
          );
        }
        return RefreshIndicator(
            onRefresh: lecData.getStudentLecturers, child: content);
      },
    );
  }
}
