import 'package:chat_app/auth/services/preferences.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'misc/constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: Constant.apiKey,
      appId: Constant.appId,
      messagingSenderId: Constant.messagingSenderId,
      projectId: Constant.projectId,
    ));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignedIn = false;
  @override
  void initState() {
    getUserLoggeinStatus();
    super.initState();
  }

  void getUserLoggeinStatus() async {
    await Preferences.getUserLogginStatus().then((value) {
      if (value != null) {
        isSignedIn = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Constant.primaryColor,
        // secondaryHeaderColor: Constant.secondaryColor,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: isSignedIn ? const HomePage() : const LoginPage(),
    );
  }
}
