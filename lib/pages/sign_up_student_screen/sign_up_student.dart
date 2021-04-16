import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/database/database.dart';
import 'package:graduation_project/pages/departments_screen/depatment.dart';
import 'package:graduation_project/pages/detection/detection_signup_screen.dart';
import 'package:graduation_project/pages/lectureres_students_screen/lectureres_students.dart';
import 'package:graduation_project/pages/log_in_screen/log_in.dart';
import 'package:graduation_project/pages/sign_up_doctor_screen/components/sign_up_card.dart';
import 'package:graduation_project/pages/sign_up_student_screen/components/select_department.dart';
import 'package:graduation_project/provider/student_provider.dart';
import 'package:graduation_project/services/facenet.service.dart';
import 'package:graduation_project/services/ml_vision_service.dart';
import 'package:graduation_project/utilities/constants.dart';
import 'package:provider/provider.dart';

/**
 * created by shaimaa salama
 */

class StudentSignUp extends StatefulWidget {
  static String routeName = '/student';

  @override
  _StudentSignUpState createState() => _StudentSignUpState();
}

class _StudentSignUpState extends State<StudentSignUp> {
  CameraDescription cameraDescription;

  /// for dropdown menu
  String initialDepartment = departments[0];
  String initialSection = arch_classes[0];
  List<String> sections = arch_classes;

  String nameTextFieldValue;
  String emailTexttFieldValue;
  String passwordTextFieldValue;
  String numberTextFieldValue;
  String confirmPasswordTextFieldValue;

  Future<void> submit() async {
    if (nameTextFieldValue.isEmpty ||
        emailTexttFieldValue.isEmpty ||
        passwordTextFieldValue.isEmpty ||
        confirmPasswordTextFieldValue.isEmpty ||
        numberTextFieldValue.isEmpty) {
      _showMyDialog('Not Leave Empty Fields');
    } else if (nameTextFieldValue.isNotEmpty &&
        emailTexttFieldValue.isNotEmpty &&
        passwordTextFieldValue.isNotEmpty &&
        confirmPasswordTextFieldValue.isNotEmpty &&
        numberTextFieldValue.isNotEmpty) {
      if (passwordTextFieldValue != confirmPasswordTextFieldValue) {
        _showMyDialog('Confirmed Password is Wrong--');
      } else {
        final result =
            await Provider.of<StudentProvider>(context, listen: false).signUp(
          name: nameTextFieldValue.toString(),
          email: emailTexttFieldValue.toString().trim(),
          password: passwordTextFieldValue.toString(),
          number: numberTextFieldValue.toString(),
          department: initialDepartment,
          section: initialSection,
          abscence: false,
        );

        if (result['success']) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetectionSignUpScreen(
                        cameraDescription: cameraDescription,
                      )));
        } else {
          if (result['error'].toString().contains(kNetworkFieldCond)) {
            _showMyDialog('kNetworkFieldMessage');
          } else {
            _showMyDialog(result['error'].toString());
          }
        }
      }
    }
  }

  Future<void> _showMyDialog(String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notice'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _startUp();
  }

  _startUp() async {
    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                Image(
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                  image: AssetImage('assets/images/student.png'),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Sign Up As Student',
                  style: TextStyle(fontSize: 20, color: primaryDark),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BuildNameField()),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BuildEmailField()),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BuildNumberField()),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BuildPasswordField()),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BuildConfirmPasswordField()),
                Padding(
                    padding: EdgeInsets.all(8.0), child: DepartmentsDropDown()),
                Padding(
                    padding: EdgeInsets.all(8.0), child: SectionsDropDown()),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: primaryLight,
                      border: Border.all(
                        color: primaryLight,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FlatButton(
                        color: primaryLight,
                        textColor: Colors.white,
                        onPressed: () {
                          /// complete signup using image processing
                          submit();
                        },
                        child: Text(
                          'SignUp',
                          style: TextStyle(fontSize: 25.0),
                        ))),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Already Have an Account ?'),
                    SizedBox(
                      width: 2,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LogInScreen(
                                        log: 2,
                                      )));
                        },
                        child: Text(
                          'LogIn',
                          style: TextStyle(color: primaryLight),
                        )),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget BuildEmailField() {
    return Card(
        elevation: 5.0,
        child: ListTile(
          leading: Icon(
            Icons.email,
            color: primaryLight,
          ),
          title: TextField(
            decoration: InputDecoration(
              hintText: 'Email',
              border: InputBorder.none,
              hintStyle: TextStyle(color: primaryLight),
            ),
            onChanged: (value) {
              emailTexttFieldValue = value;
            },
          ),
        ));
  }

  Widget BuildNameField() {
    return Card(
        elevation: 5.0,
        child: ListTile(
          leading: Icon(
            Icons.person,
            color: primaryLight,
          ),
          title: TextField(
            decoration: InputDecoration(
              hintText: 'Name',
              border: InputBorder.none,
              hintStyle: TextStyle(color: primaryLight),
            ),
            onChanged: (value) {
              nameTextFieldValue = value;
            },
          ),
        ));
  }

  Widget BuildNumberField() {
    return Card(
        elevation: 5.0,
        child: ListTile(
          leading: Icon(
            Icons.account_box,
            color: primaryLight,
          ),
          title: TextField(
            decoration: InputDecoration(
              hintText: 'Number',
              border: InputBorder.none,
              hintStyle: TextStyle(color: primaryLight),
            ),
            onChanged: (value) {
              numberTextFieldValue = value;
            },
          ),
        ));
  }

  Widget BuildPasswordField() {
    return Card(
        elevation: 5.0,
        child: ListTile(
          leading: Icon(
            Icons.vpn_key,
            color: primaryLight,
          ),
          title: TextField(
            decoration: InputDecoration(
              hintText: 'Password',
              border: InputBorder.none,
              hintStyle: TextStyle(color: primaryLight),
            ),
            onChanged: (value) {
              passwordTextFieldValue = value;
            },
          ),
        ));
  }

  Widget BuildConfirmPasswordField() {
    return Card(
        elevation: 5.0,
        child: ListTile(
          leading: Icon(
            Icons.vpn_key,
            color: primaryLight,
          ),
          title: TextField(
            decoration: InputDecoration(
              hintText: 'Confirm Password',
              border: InputBorder.none,
              hintStyle: TextStyle(color: primaryLight),
            ),
            onChanged: (value) {
              confirmPasswordTextFieldValue = value;
            },
          ),
        ));
  }

  ///widgets in screen
  Widget DepartmentsDropDown() {
    return Card(
        elevation: 5.0,
        child: ListTile(
          leading: Icon(
            Icons.circle,
            color: primaryLight,
          ),
          title: DropdownButton<String>(
            isExpanded: true,
            value: initialDepartment,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: primaryLight, fontSize: 18),
            onChanged: (String data) {
              setState(() {
                initialDepartment = data;

                if (initialDepartment == departments[0]) {
                  sections = arch_classes;
                  initialSection = arch_classes[0];
                } else if (initialDepartment == departments[1]) {
                  sections = electric_classes;
                  initialSection = electric_classes[0];
                } else if (initialDepartment == departments[2]) {
                  sections = computer_classes;
                  initialSection = computer_classes[0];
                } else {
                  sections = takteet_classes;
                  initialSection = takteet_classes[0];
                }
              });
            },
            items: departments.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ));
  }

  Widget SectionsDropDown() {
    return Card(
        elevation: 5.0,
        child: ListTile(
          leading: Icon(
            Icons.perm_contact_cal_outlined,
            color: primaryLight,
          ),
          title: DropdownButton<String>(
            isExpanded: true,
            value: initialSection,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: primaryLight, fontSize: 18),
            onChanged: (String data) {
              setState(() {
                initialSection = data;
              });
            },
            items: sections.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ));
  }
}
