import 'package:flutter/material.dart';
import 'package:graduation_project/pages/my_raws_screen/my_raws_page.dart';
import 'package:graduation_project/pages/sign_up_doctor_screen/sign_up_doctor.dart';
import 'package:graduation_project/pages/sign_up_student_screen/sign_up_student.dart';
import 'package:graduation_project/utilities/constants.dart';

/**
 * created by shaimaa salama
 */

class IntroScreen extends StatefulWidget {
  static String routeName = '/intro';

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                height: 200,
                width: 200,
                alignment: Alignment.center,
                image: AssetImage('assets/images/student.png'),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Select Your Rule As ',
                style: TextStyle(fontSize: 22, color: primaryDark),
                // style: TextStyle(fontSize: 50.0, color: Colors.white),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 55.0, horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150.0,
                      decoration: BoxDecoration(
                          color: primaryDark,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentSignUp()),
                          );
                        },
                        child: Text(
                          'Student',
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 150.0,
                      decoration: BoxDecoration(
                          color: primaryDark,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DoctorSignUp()),
                            );

                            /*   Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DoctorSignUp()),
                        );*/
                          },
                          child: Text(
                            'Doctor',
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
