import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ourappfyp/pages/MainDashboard/MainDashboard.dart';
import 'package:ourappfyp/pages/home/HomePage.dart';
import 'package:ourappfyp/pages/login/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ourappfyp/pages/register/RegistrationPage.dart';
import 'package:ourappfyp/pages/settings/Settings.dart';
import 'package:ourappfyp/pages/call/CallScreen.dart';
import 'package:ourappfyp/pages/chat_dash/chat.dart';
import 'package:ourappfyp/pages/settings/profileSetting.dart';
import 'package:ourappfyp/types/UserClass.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    try {
      await Hive.initFlutter();
      Hive.registerAdapter(UserClassAdapter());
      await Hive.openBox<UserClass>('userBox');
    } catch (e) {
      print("error loading hive error : $e");
    }
    runApp(const MyApp());
  } catch (error) {
    print("Firebase initialization error: $error");
    // Handle the error here, potentially show a message to the user
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.a
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      //  home: RegistrationPage()
      initialRoute: '/profileSetting',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/callScreen': (context) => const CallScreen(),
        '/MainDashBoard': (context) => const MainDashBoard(),
        '/Settings': (context) => SettingsPage(),
        '/profileSetting':(context) => ProfileScreen(),
      },
    );
  }
}
