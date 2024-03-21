import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ourappfyp/Components/Button.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

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
            onPressed: () => {Navigator.pushNamed((context), '/login')},
            width: imageSize,
            height: (screenSize.height * .06),
          ),
          const SizedBox(height: 20), // Passing text to the button
          Button(
            text: 'Register',
            // ignore: avoid_print
            onPressed: () => {Navigator.pushNamed((context), '/register')},
            width: imageSize,
            height: (screenSize.height * .06),
          ), // Passing text to the button
        ],
      ),
    );
  }
}
