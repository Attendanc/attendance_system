import 'package:flutter/cupertino.dart';
import 'package:graduation_project/pages/add_lecture_screen/add_lecture.dart';
import 'package:graduation_project/pages/all_lecturerers/all_lecturers.dart';
import 'package:graduation_project/pages/chat_page/chat_screen.dart';
import 'package:graduation_project/pages/departments_screen/depatment.dart';
import 'package:graduation_project/pages/detection/detection_signup_screen.dart';
import 'package:graduation_project/pages/lectureres_students_screen/lectureres_students.dart';
import 'package:graduation_project/pages/notification_screen/notification_page.dart';
import 'package:graduation_project/pages/profile_screen/profile_doctor_page.dart';
import 'package:graduation_project/pages/profile_screen/profile_student_page.dart';
import 'package:graduation_project/pages/search_students/search_students.dart';
import 'package:graduation_project/pages/splash_screen/splash_page.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (BuildContext context) => SplashScreen(),
  DepartmentScreen.routeName: (BuildContext context) => DepartmentScreen(),
  LecturersStudentsScreen.routeName: (BuildContext context) =>
      LecturersStudentsScreen(),
  ProfileDoctorPage.routeName: (BuildContext contxt) => ProfileDoctorPage(),
  AddLectureScreen.routeName: (BuildContext context) => AddLectureScreen(),
  DetectionSignUpScreen.routeName: (BuildContext context) =>
      DetectionSignUpScreen(),
  ProfileStudentPage.routeName: (BuildContext context) => ProfileStudentPage(),
  NotificationPage.routeName: (BuildContext context) => NotificationPage(),
  SearchStudents.routeName: (BuildContext context) => SearchStudents(),
  AllDoctors.routeName: (BuildContext context) => AllDoctors(),
  ChatScreen.routeName: (BuildContext context) => ChatScreen()
};
