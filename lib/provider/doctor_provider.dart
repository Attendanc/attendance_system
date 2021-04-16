import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/model/Doctor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorProvider extends ChangeNotifier {
  Doctor _doctor;
  bool _isLoading;
  bool _isAuthenticated;
  List<Doctor> _allDoctors;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isLoading => _isLoading;

  bool get isAuthenticated => _isAuthenticated;

  Doctor get doctor => _doctor;
  List<Doctor> get allDoctor => _allDoctors;

  Future<Map<String, dynamic>> signUp(
      {String name, String email, String password}) async {
    Map<String, dynamic> result = {'success': false, 'error': null};

    _isLoading = true;
    notifyListeners();

    try {
      final User doctor = (await _auth.createUserWithEmailAndPassword(
              email: email.trim(), password: password))
          .user;

      print("user email is  " + doctor.email);

      if (doctor != null) {
        final Map<String, dynamic> userData = {
          "uid": doctor.uid,
          "name": name,
          "email": email,
          "password": password
        };

        await FirebaseFirestore.instance
            .collection('/doctors')
            .doc(doctor.uid)
            .set(userData)
            .then((value) {
          final userData = Doctor(
              uid: doctor.uid, name: name, email: email, password: password);

          _doctor = userData;
          storeAuthUser(doctor.uid, true);

          result['success'] = true;
          print("result sign up " + result['success'].toString());
        }).catchError((onError) {
          result['error'] = onError;
          print("result catch sign up " + result['error'].toString());
        });
      } else {
        result['error'] = doctor;
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
          print("sign in error ");
        }
      }
    } catch (error) {
      result['error'] = error;
      print("sign in catch error is $error ");
    }
    _isLoading = false;
    notifyListeners();

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
          .collection('doctors')
          .doc(uId)
          .get()
          .then((value) {
        final userData = Doctor(
            uid: uId,
            name: value.get('name'),
            email: value.get('email'),
            password: value.get('password'));

        _doctor = userData;

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
        .collection('doctors')
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
    preferences.getBool('doctorExistence') != null
        ? isAuthenticated = preferences.getBool('doctorExistence')
        : isAuthenticated = false;
    if (isAuthenticated) {
      String uId = preferences.getString('doctorId');
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
      preferences.setBool('doctorExistence', true);
      preferences.setString('doctorId', uId);
    } else {
      preferences.remove('doctorId');
      preferences.remove('doctorExistence');
    }
  }

  Future<Map<String, dynamic>> getDoctorInfo() async {
    String doctorId = "";
    Doctor doctor;

    final Map<String, dynamic> result = {'success': false, 'error': null};

    _isLoading = true;

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.getBool('doctorExistence') != null &&
        preferences.getString('doctorId') != null) {
      doctorId = preferences.getString('doctorId');

      print("doctor preferences id is $doctorId ");

      try {
        await FirebaseFirestore.instance
            .collection('doctors')
            .doc(doctorId)
            .get()
            .then((value) => {
                  doctor =
                      Doctor(name: value.get('name'), email: value.get('email'))
                });

        _doctor = doctor;
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

  Future<Map<String, dynamic>> getAllDoctors() async {
    final Map<String, dynamic> result = {'success': false, 'error': null};

    List<Doctor> doctorList = [];

    _isLoading = true;
    //notifyListeners();

    try {
      var snapShot = await FirebaseFirestore.instance
          .collection('doctors')
          .get()
          .catchError((e) {
        result['error'] = e.toString();
      });

      snapShot.docs.forEach((d) {
        var doctor = Doctor(
            name: d.get('name'),
            email: d.get('email'),
            password: d.get('password'));

        doctorList.add(doctor);
      });

      _allDoctors = doctorList;

      result['success'] = true;
    } catch (error) {
      result['error'] = error;
    }
    _isLoading = false;
    notifyListeners();

    return result;
  }

  Future<Map<String, dynamic>> updateDoctor(String imageUrl) async {
    Map<String, dynamic> result = {'success': false, 'error': null};

    String doctorId = "";
    Doctor doctor;

    _isLoading = true;
    notifyListeners();

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.getBool('doctorExistence') != null &&
        preferences.getString('doctorId') != null) {
      doctorId = preferences.getString('studentId');

      print("student preferences id is $doctorId ");

      await FirebaseFirestore.instance
          .collection('students')
          .doc(doctorId)
          .get()
          .then((value) => {
                doctor = Doctor(
                  name: value.get('name'),
                  uid: value.get('uid'),
                  email: value.get('email'),
                  password: value.get('password'),
                )
              });

      Map<String, dynamic> studentMap = {
        "name": doctor.name,
        "uid": doctor.uid,
        "email": doctor.email,
        "password": doctor.password,
        "imagePath": imageUrl
      };

      try {
        await FirebaseFirestore.instance
            .collection('students')
            .doc(doctorId)
            .update(studentMap)
            .then((value) => {print("doctor updated successfully ---")})
            .catchError((error) {
          print("error update student   $error ==");
        });
      } catch (error) {
        result['error'] = error;
        print("catch error update doctor  $error ==");
      }
    } else {
      result['error'] = "doctorId is null ======";
      print("error get doctor from preferences   ${result['error']} ==");
    }

    _isLoading = false;
    notifyListeners();

    return result;
  }
}
