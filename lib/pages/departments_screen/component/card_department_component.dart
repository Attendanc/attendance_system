import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/utilities/constants.dart';

class DepartmentCard extends StatefulWidget {
  DepartmentCard({@required this.departname});

  String departname;

  @override
  _DepartmentCardState createState() => _DepartmentCardState();
}

class _DepartmentCardState extends State<DepartmentCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
            decoration: BoxDecoration(
              color: primaryDark,
              border: Border.all(
                color: primaryDark,
                width: 8,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: new Text(
                widget.departname,
                style: TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            )),
      ),
    );
  }
}
