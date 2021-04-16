import 'package:flutter/material.dart';
import 'package:graduation_project/utilities/constants.dart';

import 'components/body.dart';

class AllDoctors extends StatefulWidget {
  static String routeName = "/all_doctors";

  @override
  _AllDoctorsState createState() => _AllDoctorsState();
}

class _AllDoctorsState extends State<AllDoctors> {
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
