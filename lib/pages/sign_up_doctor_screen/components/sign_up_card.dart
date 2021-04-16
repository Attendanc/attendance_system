import 'package:flutter/material.dart';
import 'package:graduation_project/utilities/constants.dart';

class CardSignUp extends StatelessWidget {
  CardSignUp({@required this.data, this.hintedText});

  IconData data;
  String hintedText;
  String textFieldValue;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5.0,
        child: ListTile(
          leading: Icon(
            data,
            color: primaryLight,
          ),
          title: TextField(
            decoration: InputDecoration(
              hintText: hintedText,
              border: InputBorder.none,
              hintStyle: TextStyle(color: primaryLight),
            ),
            onChanged: (value) {
              textFieldValue = value;
            },
          ),
        ));
  }
}
