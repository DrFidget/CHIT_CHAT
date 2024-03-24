import 'package:flutter/material.dart';
import 'package:ourappfyp/pages/login/LoginPage.dart';
import 'package:ourappfyp/pages/home/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ourappfyp/pages/register/RegistrationPage.dart';
import 'package:ourappfyp/pages/call/CallScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (error) {
    print("Firebase initialization error: $error");
    // Handle the error here, potentially show a message to the user
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      //  home: RegistrationPage()
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/callScreen': (context) => const CallScreen(),
      },
    );
  }
}
