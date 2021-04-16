import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:graduation_project/model/Student.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentProvider extends ChangeNotifier {
  Student _student;
  bool _isLoading;
  bool _isAuthenticated;
  List<Student> _allStudents;

  List<Student> get allStudents => _allStudents;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Student get student => _student;
  bool get isLoading => _isLoading;

  bool get isAuthenticated => _isAuthenticated;

  Future<Map<String, dynamic>> signUp(
      {String name,
      String email,
      String password,
      String number,
      String section,
      String department,
      bool abscence}) async {
    Map<String, dynamic> result = {'success': false, 'error': null};

    _isLoading = true;
    notifyListeners();
    try {
      final User student = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      print("user email is  " + student.email);

      if (student != null) {
        final Map<String, dynamic> userData = {
          "uid": student.uid,
          "name": name,
          "email": email,
          "password": password,
          "number": number,
          "department": department,
          "section": section,
          "abscence": abscence
        };
        await FirebaseFirestore.instance
            .collection('/students')
            .doc(student.uid)
            .set(userData)
            .then((value) {
          final userData = Student(
              uid: student.uid, name: name, email: email, password: password);
          _student = userData;

          storeAuthUser(student.uid, true);

          result['success'] = true;
          print("result sign up " + result['success'].toString());
        }).catchError((onError) {
          result['error'] = onError;
          print("result catch sign up " + result['error'].toString());
        });
      } else {
        result['error'] = student;
        print("result error  sign up " + result['error'].toString());
      }
    } catch (error) {
      result['error'] = error;
      print("result catch sign up " + result['error'].toString());
    }
    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> signIn({String email, String password}) async {
    final Map<String, dynamic> result = {'success': false, 'error': null};

    _isLoading = true;
    notifyListeners();

    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;

      if (user != null) {
        final userData = await fetchUserData(user.uid);
        if (userData['success']) {
          storeAuthUser(user.uid, true);
          result['success'] = true;
        } else {
          result['error'] = "Can't load your data";
        }
      }
    } catch (error) {
      result['error'] = error;
    }
    _isLoading = false;
    notifyListeners();
    print("result sign in google " + result['error'].toString());

    return result;
  }

  Future<Map<String, dynamic>> signOut() async {
    final Map<String, dynamic> result = {'success': false, 'error': null};
    final user = _auth.currentUser;
    await _auth.signOut().then((value) {
      storeAuthUser(user.uid);
      result['success'] = true;
    }).catchError((error) {
      result['error'] = error;
    });
    return result;
  }

  Future<Map<String, dynamic>> sendEmailForResetPassword(String email) async {
    Map<String, dynamic> result = {'success': true, 'error': null};
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.sendPasswordResetEmail(email: email).catchError((error) {
        result['success'] = false;
        result['error'] = error;
      });
    } catch (error) {
      result['success'] = false;
      result['error'] = error;
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<Map<String, dynamic>> fetchUserData(String uId) async {
    final Map<String, dynamic> result = {'success': false, 'error': null};
    _isLoading = true;
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(uId)
          .get()
          .then((value) {
        final userData = Student(
            uid: uId,
            name: value.get('name'),
            email: value.get('email'),
            password: value.get('password'),
            number: value.get("number"),
            department: value.get("department"),
            section: value.get("section"),
            abscence: value.get("abscence"));

        _student = userData;

        result['success'] = true;
      }).catchError((error) {
        result['error'] = error;
      });
    } catch (error) {
      result['error'] = error;
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<bool> checkUserExistence(String uId) async {
    bool exist = false;
    await FirebaseFirestore.instance
        .collection('students')
        .doc(uId)
        .get()
        .then((value) {
      if (value.exists) {
        exist = true;
      }
    });
    return exist;
  }

  Future<void> autoAuthenticated() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isAuthenticated;
    preferences.getBool('studentExistence') != null
        ? isAuthenticated = preferences.getBool('studentExistence')
        : isAuthenticated = false;
    if (isAuthenticated) {
      String uId = preferences.getString('studentId');
      final userData = await fetchUserData(uId);
      if (userData['success']) {
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
      }
    } else {
      return;
    }
  }

  void storeAuthUser(String uId, [isAuth = false]) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if (isAuth) {
      preferences.setBool('studentExistence', true);
      preferences.setString('studentId', uId);
    } else {
      preferences.remove('studentId');
      preferences.remove('studentExistence');
    }
  }

  Future<Map<String, dynamic>> setStudentAbscence() async {
    Map<String, dynamic> result = {'success': false, 'error': null};

    String studentId = "";
    Student student;

    _isLoading = true;
    notifyListeners();

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.getBool('studentExistence') != null &&
        preferences.getString('studentId') != null) {
      studentId = preferences.getString('studentId');

      print("student preferences id is $studentId ");

      await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .get()
          .then((value) => {
                student = Student(
                    name: value.get('name'),
                    uid: value.get('uid'),
                    email: value.get('email'),
                    number: value.get('number'),
                    password: value.get('password'),
                    abscence: value.get('abscence'),
                    section: value.get('section'),
                    department: value.get('department'))
              });

      Map<String, dynamic> studentMap = {
        "abscence": true,
        "name": student.name,
        "uid": student.uid,
        "email": student.email,
        "number": student.number,
        "password": student.password,
        "section": student.section,
        "department": student.department
      };

      try {
        await FirebaseFirestore.instance
            .collection('students')
            .doc(studentId)
            .update(studentMap)
            .then((value) => {print("student updated successfully ---")})
            .catchError((error) {
          print("error update student   $error ==");
        });
      } catch (error) {
        result['error'] = error;
        print("catch error update student  $error ==");
      }
    } else {
      result['error'] = "studentId is null ======";
      print("error get student from preferences   ${result['error']} ==");
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> getStudentInfo() async {
    String studentId = "";
    Student student;

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
                      name: value.get('name'),
                      number: value.get('number'),
                      section: value.get('section'),
                      department: value.get('department'),
                      email: value.get('email'))
                });

        _student = student;
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

  /// get all students
  Future<Map<String, dynamic>> getAllStudents() async {
    final Map<String, dynamic> result = {'success': false, 'error': null};

    List<Student> studentList = [];

    _isLoading = true;
    //notifyListeners();

    try {
      var snapShot = await FirebaseFirestore.instance
          .collection('students')
          .get()
          .catchError((e) {
        result['error'] = e.toString();
      });

      snapShot.docs.forEach((d) {
        var student = Student(
            uid: d.get('uid'),
            number: d.get('number'),
            name: d.get('name'),
            email: d.get('email'),
            password: d.get('password'),
            department: d.get('department'),
            section: d.get('section'));

        studentList.add(student);
      });

      _allStudents = studentList;

      result['success'] = true;
    } catch (error) {
      result['error'] = error;
    }
    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> updateStudent(String imageUrl) async {
    Map<String, dynamic> result = {'success': false, 'error': null};

    String studentId = "";
    Student student;

    _isLoading = true;
    notifyListeners();

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.getBool('studentExistence') != null &&
        preferences.getString('studentId') != null) {
      studentId = preferences.getString('studentId');

      print("student preferences id is $studentId ");

      await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .get()
          .then((value) => {
                student = Student(
                    name: value.get('name'),
                    uid: value.get('uid'),
                    email: value.get('email'),
                    number: value.get('number'),
                    password: value.get('password'),
                    abscence: value.get('abscence'),
                    section: value.get('section'),
                    department: value.get('department'))
              });

      Map<String, dynamic> studentMap = {
        "abscence": true,
        "name": student.name,
        "uid": student.uid,
        "email": student.email,
        "number": student.number,
        "password": student.password,
        "section": student.section,
        "department": student.department,
        "imagePath": imageUrl
      };

      try {
        await FirebaseFirestore.instance
            .collection('students')
            .doc(studentId)
            .update(studentMap)
            .then((value) => {print("student updated successfully ---")})
            .catchError((error) {
          print("error update student   $error ==");
        });
      } catch (error) {
        result['error'] = error;
        print("catch error update student  $error ==");
      }
    } else {
      result['error'] = "studentId is null ======";
      print("error get student from preferences   ${result['error']} ==");
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }
}
