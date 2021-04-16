import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graduation_project/pages/filter_lectures/filter_lectures.dart';
import 'package:graduation_project/pages/section_screen/components/section_list_item.dart';
import 'package:graduation_project/provider/lecture_provider.dart';
import 'package:graduation_project/utilities/constants.dart';
import 'package:provider/provider.dart';

class SectionsScreen extends StatefulWidget {
  static String routeName = '/sections';

  List<String> sections;
  String department;

  SectionsScreen({@required this.sections, @required this.department});

  @override
  _SectionsScreenState createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen> {
  @override
  void initState() {
    Provider.of<LectureProvider>(context, listen: false)
        .getFiteredLecturers(widget.sections[0], widget.department);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
                margin: EdgeInsets.all(16),
                child: Text(
                  'All Sections',
                  style: TextStyle(
                    fontSize: 20,
                    color: primaryDark,
                  ),
                )),
            SizedBox(
              height: 30,
            ),
            ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.sections.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FilterLectures(
                                  section: widget.sections[index],
                                  department: widget.department,
                                )));

                    Provider.of<LectureProvider>(context, listen: false)
                        .getFiteredLecturers(
                            widget.sections[index], widget.department);

                    ///sleep----
                    sleep(Duration(seconds: 1));
                  },
                  child: SectionListItem(
                    sectionName: widget.sections[index],
                    color: primaryDark,
                  ),
                );
              },
            ),
          ],
        ));
  }
}
