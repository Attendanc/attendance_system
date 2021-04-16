import 'package:flutter/material.dart';
import 'package:graduation_project/pages/departments_screen/depatment.dart';
import 'package:graduation_project/pages/forget_password/forget_password.dart';
import 'package:graduation_project/pages/lectureres_students_screen/lectureres_students.dart';
import 'package:graduation_project/pages/sign_up_doctor_screen/components/sign_up_card.dart';
import 'package:graduation_project/provider/doctor_provider.dart';
import 'package:graduation_project/provider/lecture_provider.dart';
import 'package:graduation_project/provider/student_provider.dart';
import 'package:graduation_project/utilities/constants.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatefulWidget {
  static String routeName = '/login';

  int log;
  LogInScreen({this.log});

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  String emailTextField;
  String passwordTextFied;

  @override
  void initState() {
    super.initState();

    Provider.of<LectureProvider>(context, listen: false).getStudentLecturers();
  }

  Future<void> onSubmitDoctor() async {
    if (emailTextField.isEmpty || passwordTextFied.isEmpty) {
      _showMyDialog('Not Leave Empty Fields');
    } else if (emailTextField.isNotEmpty && passwordTextFied.isNotEmpty) {
      final result = await Provider.of<DoctorProvider>(context, listen: false)
          .signIn(
              email: emailTextField.toString().trim(),
              password: passwordTextFied.toString());

      if (result['success']) {
        Navigator.pushNamed(context, DepartmentScreen.routeName);
      } else {
        if (result['error'].toString().contains(kNetworkFieldCond)) {
          _showMyDialog('kNetworkFieldMessage');
        } else {
          _showMyDialog('kEmailInUseMessage');
        }
      }
    }
  }

  Future<void> onSubmitStudent() async {
    if (emailTextField.isEmpty || passwordTextFied.isEmpty) {
      _showMyDialog('Not Leave Empty Fields');
    } else if (emailTextField.isNotEmpty && passwordTextFied.isNotEmpty) {
      final result = await Provider.of<StudentProvider>(context, listen: false)
          .signIn(
              email: emailTextField.toString().trim(),
              password: passwordTextFied.toString());

      if (result['success']) {
        Navigator.pushNamed(context, LecturersStudentsScreen.routeName);
      } else {
        if (result['error'].toString().contains(kNetworkFieldCond)) {
          _showMyDialog('kNetworkFieldMessage');
        } else {
          _showMyDialog(result['error'].toString());
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
                Text('Error Message---'),
                Text(error),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: primaryLight),
              ),
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
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          color: Colors.white,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: 50.0,
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
              'Sign Up As Doctor',
              style: TextStyle(fontSize: 20, color: primaryDark),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
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
                          emailTextField = value;
                        },
                      ),
                    ))),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    elevation: 5.0,
                    child: ListTile(
                      leading: Icon(
                        Icons.vpn_key,
                        color: primaryLight,
                      ),
                      title: TextField(
                        decoration: InputDecoration(
                          hintText: 'password',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: primaryLight),
                        ),
                        onChanged: (value) {
                          passwordTextFied = value;
                        },
                      ),
                    ))),
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
                      if (widget.log == 1) {
                        onSubmitDoctor();
                      } else {
                        onSubmitStudent();
                      }
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(fontSize: 25.0),
                    ))),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ForgetPassPage()));
              },
              child: Text(
                'Forget Password ? ',
                style: TextStyle(
                  color: primaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ])),
    );
  }
}
