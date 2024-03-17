import 'package:flutter/material.dart';
import 'package:ourappfyp/pages/login/LoginPage.dart';
import 'package:ourappfyp/pages/home/HomePage.dart';
import 'package:ourappfyp/pages/registration/RegistrationPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      //  home: RegistrationPage()
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
      },
    );
  }
}
