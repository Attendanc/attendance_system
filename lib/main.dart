import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/pages/splash_screen/splash_page.dart';
import 'package:graduation_project/provider/chat_provider.dart';
import 'package:graduation_project/provider/doctor_provider.dart';
import 'package:graduation_project/provider/lecture_provider.dart';
import 'package:graduation_project/provider/student_provider.dart';
import 'package:graduation_project/utilities/routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => DoctorProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => StudentProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => LectureProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ChatProvider(),
        )
      ],
      child: Listener(
        onPointerDown: (_) {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: SplashScreen.routeName,
          routes: routes,
        ),
      ),
    );
  }
}
