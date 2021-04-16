import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:graduation_project/model/Student.dart';
import 'package:graduation_project/model/lecture.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LectureProvider extends ChangeNotifier {
  List<Lecture> _lectures = [];
  List<Lecture> _filterLecture = [];
  List<Student> _goneStudents = [];

  bool _isLoading;

  List<Lecture> get lectures => _lectures;

  List<Lecture> get filterLecture => _filterLecture;

  List<Student> get goneStudents => _goneStudents;

  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>> getStudentLecturers() async {
    String studentId = "";
    Student student;
    List<Lecture> lecturesData = [];

    final Map<String, dynamic> result = {'success': false, 'error': null};

    _isLoading = true;

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.getBool('studentExistence') != null &&
        preferences.getString('studentId') != null) {
      studentId = preferences.getString('studentId');

      print("student preferences id is $studentId ");

      try {
        await FirebaseFirestore.instance
            .collection('students')
            .doc(studentId)
            .get()
            .then((value) => {
                  student = Student(
                      section: value.get('section'),
                      department: value.get('department'))
                });

        final lects =
            await FirebaseFirestore.instance.collection('lectures').get();

        lects.docs.forEach((lec) {
          if (student.section == lec.get("section") &&
              student.department == lec.get("department")) {
            final lecData = Lecture(
              department: lec.get("department"),
              section: lec.get("section"),
              name: lec.get('name'),
              date: lec.get('date'),
              time: lec.get('time'),
            );

            lecturesData.add(lecData);
          }
        });

        _lectures = lecturesData;
      } catch (error) {
        result['error'] = error;
        print("get lectures catch error   $error ==");
      }
    } else {
      result['error'] = "studentId is null ======";
      print("get lectures error   ${result['error']} ==");
    }
    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> storeLectures(String department, String section,
      String name, String date, String time) async {
    final Map<String, dynamic> result = {'success': false, 'error': null};

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String doctorId;

    if (preferences.getBool('doctorExistence') != null &&
        preferences.getString('doctorId') != null) {
      doctorId = preferences.getString('doctorId');
      print("doctor id is $doctorId=======");
    }
    _isLoading = true;
    notifyListeners();

    try {
      print("try to store lecturers");

      DocumentReference snapshot =
          await FirebaseFirestore.instance.collection('lectures').doc();

      var id = snapshot.id;
      result['success'] = true;
      snapshot.set({
        "name": name,
        "date": date,
        "section": section,
        "department": department,
        "time": time,
        "id": id,
        "doctorId": doctorId
      }).catchError((error) {
        result['error'] = error;
        print("error added lecture $error");
      });
      result['success'] = true;
    } catch (error) {
      result['error'] = error;
      print("error catch add lecture $error");
    }
    _isLoading = false;

    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> getFiteredLecturers(
      String section, String department) async {
    String doctorId = "";

    List<Lecture> lecturesFilter = [];

    final Map<String, dynamic> result = {'success': false, 'error': null};

    _isLoading = true;
    notifyListeners();

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.getBool('doctorExistence') != null &&
        preferences.getString('doctorId') != null) {
      doctorId = preferences.getString('doctorId');

      print("doctor preferences id is $doctorId ");

      try {
        final lects =
            await FirebaseFirestore.instance.collection('lectures').get();

        lects.docs.forEach((lec) {
          if (section == lec.get("section") &&
              department == lec.get("department") &&
              doctorId == lec.get('doctorId')) {
            final lecData = Lecture(
                department: lec.get("department"),
                section: lec.get("section"),
                name: lec.get('name'),
                date: lec.get('date'),
                time: lec.get('time'),
                doctorId: lec.get('doctorId'),
                id: lec.get('id'));

            lecturesFilter.add(lecData);
          }
        });

        _filterLecture = lecturesFilter;
      } catch (error) {
        result['error'] = error;
        print("get filter lectures catch error   $error ==");
      }
    } else {
      print("get filter lectures error   ${result['error']} ==");
    }
    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> storeGoneLectures(
      Lecture lec, Student student) async {
    final Map<String, dynamic> result = {'success': false, 'error': null};

    _isLoading = true;
    notifyListeners();

    try {
      print("try to store gone lecturers");

      await FirebaseFirestore.instance
          .collection('gone')
          .doc(lec.name + lec.time)
          .collection('students')
          .doc()
          .set({
        'name': student.name,
        'email': student.email,
        'section': student.section,
        'number': student.number,
        'department': student.department,
        'password': student.password,
        'uid': student.uid
      }).catchError((error) {
        result['error'] = error;
        print("error store gone lecturers");
      });

      result['success'] = true;
    } catch (error) {
      result['error'] = error;
      print("catch error gone lecturers");
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> getGoneLectures(Lecture lec) async {
    final Map<String, dynamic> result = {'success': false, 'error': null};

    List<Student> goneStudents = [];

    _isLoading = true;
    notifyListeners();

    try {
      print("try to get store gone lecturers");

      var students = await FirebaseFirestore.instance
          .collection('gone')
          .doc(lec.name + lec.time)
          .collection('students')
          .get()
          .catchError((error) {
        result['error'] = error;
        print("error fetch  gone lecturers");
      });

      students.docs.forEach((st) {
        var student = Student(
            name: st.get('name'),
            section: st.get('section'),
            number: st.get('number'),
            department: st.get('department'),
            email: st.get('email'),
            password: st.get('password'),
            uid: st.get('uid'));
        goneStudents.add(student);
      });

      _goneStudents = goneStudents;

      result['success'] = true;
    } catch (error) {
      result['error'] = error;
      print("catch fetch gone lecturers $error");
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }
}
