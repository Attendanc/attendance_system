import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:graduation_project/model/Doctor.dart';
import 'package:graduation_project/pages/all_lecturerers/all_lecturers.dart';
import 'package:graduation_project/pages/search_students/search_students.dart';
import 'package:graduation_project/pages/sign_up_doctor_screen/sign_up_doctor.dart';
import 'package:graduation_project/provider/doctor_provider.dart';
import 'package:graduation_project/utilities/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileDoctorPage extends StatefulWidget {
  static String routeName = "/doctor_profile";

  @override
  _ProfileDoctorPageState createState() => _ProfileDoctorPageState();
}

class _ProfileDoctorPageState extends State<ProfileDoctorPage> {
  Doctor doctor;
  File _image;

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();

    Provider.of<DoctorProvider>(context, listen: false).getDoctorInfo();
    Provider.of<DoctorProvider>(context, listen: false).getAllDoctors();

    doctor = Provider.of<DoctorProvider>(context, listen: false).doctor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(doctor.name),
        centerTitle: true,
        backgroundColor: secondaryLight,
        iconTheme: IconThemeData(color: primaryDark),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryLight),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/user.png',
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(doctor.name),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Contact Us'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Me'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: secondaryLight,
        child: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Color(0xffFDCF09),
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  _image,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(50)),
                                width: 100,
                                height: 100,
                                child: Image.asset(
                                  'assets/images/user.png',
                                  width: 100,
                                  height: 100,
                                ),
                              ))),
                SizedBox(
                  height: 10,
                ),
                Text(
                  doctor.email,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.timelapse,
                            size: 30,
                            color: primaryDark,
                          ),
                          Text('Today Lecturers',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SearchStudents.routeName);
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.people_alt,
                            size: 30,
                            color: primaryDark,
                          ),
                          Text('Search Students',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AllDoctors.routeName);
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.people,
                            size: 30,
                            color: primaryDark,
                          ),
                          Text('All Lecturers',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<DoctorProvider>(context, listen: false)
                            .signOut();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DoctorSignUp()));
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.logout,
                            size: 30,
                            color: primaryDark,
                          ),
                          Text(
                            'LogOut',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
