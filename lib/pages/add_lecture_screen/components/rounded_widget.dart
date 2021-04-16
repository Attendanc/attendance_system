import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/utilities/constants.dart';

class RoundedWidget extends StatefulWidget {
  RoundedWidget({@required this.child, @required this.icon});

  Widget child;
  IconData icon;

  @override
  _RoundedWidgetState createState() => _RoundedWidgetState();
}

class _RoundedWidgetState extends State<RoundedWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: ListTile(
          leading: Icon(
            widget.icon,
            color: primaryLight,
          ),
          title: widget.child,
        ));
  }
}
