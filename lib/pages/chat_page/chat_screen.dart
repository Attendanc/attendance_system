import 'package:flutter/material.dart';
import 'package:graduation_project/utilities/constants.dart';

import 'components/body.dart';

class ChatScreen extends StatefulWidget {
  static String routeName = "/chatting";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryLight,
      ),
      backgroundColor: Colors.white,
      body: Body(),
    );
  }
}
