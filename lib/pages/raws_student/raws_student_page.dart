import 'package:flutter/material.dart';
import 'package:graduation_project/pages/notification_screen/notification_page.dart';
import 'package:graduation_project/pages/profile_screen/profile_student_page.dart';
import 'package:graduation_project/pages/raws_student/placeholder_widget.dart';
import 'package:graduation_project/utilities/constants.dart';

class RawsStudentsPage extends StatefulWidget {
  @override
  _RawsStudentsPageState createState() => _RawsStudentsPageState();
}

class _RawsStudentsPageState extends State<RawsStudentsPage> {
  final List<Widget> _children = [
    ProfileStudentPage(),
    NotificationPage(),
    HomeWidget(),
  ];
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex,
        selectedItemColor: primaryLight,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Profile')),
          BottomNavigationBarItem(
            icon: new Icon(Icons.notifications_active),
            title: new Text('Notifications'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

/*  Widget AnimatedSearchBar() {
    return SafeArea(
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
        ),
        child: TextField(
          cursorColor: Colors.grey,
          decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: 16),
            hintText: "Search here",
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }*/

  Widget BuildNotificationsWidget() {}

  Widget BuildProfileWidget() {}

  /*
   padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: primaryLight,
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: IconButton(
                icon: Icon(
                  Icons.filter_list,
                  color: primaryLight,
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(child: AnimatedSearchBar())
          ],
        ),
   */
}
