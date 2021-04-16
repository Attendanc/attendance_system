import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/utilities/constants.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageItem extends StatefulWidget {
  final String sender;
  final String text;

  MessageItem({this.sender, this.text});

  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  SharedPreferences preferences;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User currentUser;
  String uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentUser = _auth.currentUser;
    uid = currentUser.uid;

    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: widget.sender == uid
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(widget.sender),
          SizedBox(
            height: 8,
          ),
          Material(
            color:
                widget.sender == uid ? primaryLight : Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(10),
            elevation: 6,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  widget.text,
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }
}
