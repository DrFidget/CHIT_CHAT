import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ourappfyp/Components/Button.dart';
import 'package:ourappfyp/types/UserClass.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Call your method here using postFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onMount();
    });
  }

  void onMount() {
    final userBox = Hive.box<UserClass>('userBox');
    if (userBox.isEmpty) {
      // Navigator.pushNamed(context, '/login');
    } else {
      Navigator.pushNamed(context, '/MainApp');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final Size screenSize = MediaQuery.of(context).size;

    // Calculate the appropriate size for the image and spacing
    final double imageSize = screenSize.width * 0.8;
    final double verticalSpacing = screenSize.height * 0.15;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(3, 7, 18, 1), // Set alpha to 255
      body: Column(
        children: [
          SizedBox(height: verticalSpacing),
          Center(
            child: Image.asset(
              'assets/chitchat.png',
              width: imageSize,
              height: imageSize,
            ),
          ),
          SizedBox(height: verticalSpacing),
          Button(
            text: 'Login',

            // ignore: avoid_print
            onPressed: () => Navigator.pushNamed(context, '/login'),
            width: imageSize,
            height: screenSize.height * .06,
          ),
          const SizedBox(height: 20), // Passing text to the button
          Button(
            text: 'Register',
            // ignore: avoid_print
            onPressed: () => Navigator.pushNamed(context, '/register'),
            width: imageSize,
            height: screenSize.height * .06,
            // Apply Jockey One font
          ), // Passing text to the button
        ],
      ),
    );
  }
}
