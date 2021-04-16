import 'package:flutter/material.dart';
import 'package:graduation_project/provider/doctor_provider.dart';
import 'package:graduation_project/utilities/constants.dart';
import 'package:provider/provider.dart';

class ForgetPassPage extends StatefulWidget {
  @override
  _ForgetPassPageState createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends State<ForgetPassPage> {
  String emailTextField;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/student.png',
                width: 100,
                height: 100,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: TextField(
                  onChanged: (value) {
                    emailTextField = value;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Email'),
                ),
              ),
              SizedBox(
                height: 15,
              ),
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
                      onPressed: () async {
                        await Provider.of<DoctorProvider>(context,
                                listen: false)
                            .sendEmailForResetPassword(
                                emailTextField.toString());
                      },
                      child: Text(
                        'Send Reset Password Link',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
