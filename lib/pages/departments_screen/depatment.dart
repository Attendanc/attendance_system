import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/pages/add_lecture_screen/add_lecture.dart';
import 'package:graduation_project/pages/profile_screen/profile_doctor_page.dart';
import 'package:graduation_project/pages/section_screen/components/section_list_item.dart';
import 'package:graduation_project/pages/section_screen/section.dart';
import 'package:graduation_project/provider/doctor_provider.dart';
import 'package:graduation_project/utilities/constants.dart';
import 'package:provider/provider.dart';

class DepartmentScreen extends StatefulWidget {
  static String routeName = '/department';

  @override
  _DepartmentScreenState createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  @override
  void initState() {
    Provider.of<DoctorProvider>(context, listen: false).getDoctorInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ProfileDoctorPage.routeName);
                    },
                    child: Image.asset(
                      'assets/images/user.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Welcom Dr,',
                    style: TextStyle(fontSize: 20, color: primaryDark),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Shaimaa',
                    style: TextStyle(fontSize: 20, color: primaryDark),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              GridView.count(
                crossAxisCount: 2,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                padding: EdgeInsets.only(left: 16, right: 16),
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                children: departmentsShow.map((e) {
                  return GestureDetector(
                    onTap: () {
                      var index = departmentsShow.indexOf(e, 0);
                      print("index is $index");
                      if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SectionsScreen(
                                    sections: arch_classes,
                                    department: departmentsShow[0],
                                  )),
                        );
                      } else if (index == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SectionsScreen(
                                    sections: electric_classes,
                                    department: departmentsShow[1],
                                  )),
                        );
                      } else if (index == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SectionsScreen(
                                    sections: computer_classes,
                                    department: departmentsShow[2],
                                  )),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SectionsScreen(
                                    sections: takteet_classes,
                                    department: departmentsShow[3],
                                  )),
                        );
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: primaryDark,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Image.asset(
                            'assets/images/student.png',
                            height: 60,
                            width: 60,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(e.toString(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ))),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              SectionListItem(sectionName: 'اعدادي هندسة', color: primaryDark),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddLectureScreen()));
        },
        child: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: primaryDark,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0))),
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Add Lecture',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }
}
