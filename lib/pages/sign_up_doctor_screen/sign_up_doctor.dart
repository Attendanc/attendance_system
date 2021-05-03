import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/pages/departments_screen/depatment.dart';
import 'package:graduation_project/pages/log_in_screen/log_in.dart';
import 'package:graduation_project/pages/my_raws_screen/my_raws_page.dart';
import 'package:graduation_project/provider/doctor_provider.dart';
import 'package:graduation_project/utilities/constants.dart';
import 'package:provider/provider.dart';

class DoctorSignUp extends StatefulWidget {
  static String routeName = '/doctor';

  @override
  _DoctorSignUpState createState() => _DoctorSignUpState();
}

class _DoctorSignUpState extends State<DoctorSignUp> {
  static String routeName = '/deparment';

  bool isShown1 = true;
  bool isShown2 = true;

  String nameTextFieldValue;
  String emailTexttFieldValue;
  String passwordTextFieldValue;
  String confirmPasswordTextFieldValue;

  Future<void> submit() async {
    if (nameTextFieldValue.isEmpty ||
        emailTexttFieldValue.isEmpty ||
        passwordTextFieldValue.isEmpty ||
        confirmPasswordTextFieldValue.isEmpty) {
      _showMyDialog('Not Leave Empty Fields');
    } else if (nameTextFieldValue.isNotEmpty &&
        emailTexttFieldValue.isNotEmpty &&
        passwordTextFieldValue.isNotEmpty &&
        confirmPasswordTextFieldValue.isNotEmpty) {
      if (passwordTextFieldValue != confirmPasswordTextFieldValue) {
        _showMyDialog('Confirmed Password is Wrong--');
      } else {
        final result = await Provider.of<DoctorProvider>(context, listen: false)
            .signUp(
                name: nameTextFieldValue.toString(),
                email: emailTexttFieldValue.toString().trim(),
                password: passwordTextFieldValue.toString());

        if (result['success']) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyRawsScreen()));
        } else {
          if (result['error'].toString().contains(kNetworkFieldCond)) {
            _showMyDialog('kNetworkFieldMessage');
          } else {
            _showMyDialog('kEmailInUseMessage');
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
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
                'Sign Up As Doctor',
                style: TextStyle(fontSize: 20, color: primaryDark),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(padding: const EdgeInsets.all(8.0), child: BuildName()),
              Padding(padding: const EdgeInsets.all(8.0), child: BuildEmail()),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BuildPasswordField()),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BuildConfirmPasswordField()),
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
                                      log: 1,
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
    );
  }

  Widget BuildEmail() {
    return TextField(
      decoration: new InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
          prefixIcon: Icon(
            Icons.email,
            color: primaryLight,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          )),
      onChanged: (value) {
        emailTexttFieldValue = value;
      },
    );
  }

  Widget BuildPasswordField() {
    return TextField(
      obscureText: isShown1,
      decoration: InputDecoration(
        hintText: 'password',
        prefixIcon: Icon(
          Icons.lock,
          color: primaryLight,
        ),
        border: OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(isShown1 ? Icons.visibility_off : Icons.visibility),
          onPressed: showOrHide1,
        ),
      ),
      onChanged: (value) {
        passwordTextFieldValue = value;
      },
    );
  }

  Widget BuildConfirmPasswordField() {
    return TextField(
      obscureText: isShown2,
      decoration: InputDecoration(
        hintText: 'confirm password',
        prefixIcon: Icon(
          Icons.lock,
          color: primaryLight,
        ),
        border: OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(isShown2 ? Icons.visibility_off : Icons.visibility),
          onPressed: showOrHide2,
        ),
      ),
      onChanged: (value) {
        confirmPasswordTextFieldValue = value;
      },
    );
  }

  Widget BuildName() {
    return TextField(
      decoration: new InputDecoration(
          labelText: 'Name',
          border: OutlineInputBorder(),
          prefixIcon: Icon(
            Icons.person,
            color: primaryLight,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          )),
      onChanged: (value) {
        nameTextFieldValue = value;
      },
    );
  }

  showOrHide1() {
    setState(() {
      isShown1 = !isShown1;
    });
  }

  showOrHide2() {
    setState(() {
      isShown2 = !isShown2;
    });
  }
}
