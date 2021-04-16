import 'package:flutter/material.dart';
import 'package:graduation_project/utilities/constants.dart';

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  SendButton({this.text, this.callback});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: primaryLight,
      onPressed: callback,
      icon: Icon(Icons.send),
    );
  }
}
