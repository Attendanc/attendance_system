import 'package:flutter/material.dart';
import 'package:graduation_project/pages/add_lecture_screen/add_lecture.dart';
import 'package:graduation_project/pages/add_new_raw/add_raw_page.dart';
import 'package:graduation_project/utilities/constants.dart';

class MyRawsScreen extends StatefulWidget {
  @override
  _MyRawsScreenState createState() => _MyRawsScreenState();
}

class _MyRawsScreenState extends State<MyRawsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5.0,
        child: Icon(Icons.add),
        backgroundColor: primaryLight,
        foregroundColor: Colors.black,
        onPressed: () {
          _settingModalBottomSheet(context);
        },
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    title: new Text('انشاء صف'),
                    onTap: () => {
                          // start activity with animation
                          Navigator.of(context).push(_createRoute())
                        }),
                new ListTile(
                  title: new Text('الانضمام الي صف'),
                  onTap: () => {},
                ),
              ],
            ),
          );
        });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          AddNewRawScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
