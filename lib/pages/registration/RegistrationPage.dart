import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourappfyp/Components/Button.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late String fullName;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double verticalSpacing = screenSize.height * 0.05;
    final double WidthOfFields = screenSize.width * 0.8;
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 7, 18, 1),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: verticalSpacing),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Color.fromRGBO(3, 7, 18, 1),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
                title: Text(
                  "ChitChat",
                  style: GoogleFonts.jockeyOne(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 40,
                    ),
                  ),
                ),
                centerTitle: true,
              ),
              SizedBox(height: verticalSpacing),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back!',
                    style: GoogleFonts.jockeyOne(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  const Text(
                    'Full Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  inputField(
                    hintText: 'Enter your full name',
                    prefixIcon: Icons.person,
                    width: WidthOfFields,
                    onChanged: (value) {
                      setState(() {
                        fullName = value;
                      });
                      // print(fullName);
                    },
                  ),
                  const SizedBox(height: 45),
                  const Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  inputField(
                    hintText: 'Enter your email',
                    prefixIcon: Icons.email,
                    width: WidthOfFields,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                      // print(email);
                    },
                  ),
                  const SizedBox(height: 45),
                  const Text(
                    'Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  inputField(
                    hintText: 'Enter your password',
                    prefixIcon: Icons.password,
                    width: WidthOfFields,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                      // print(password);
                    },
                    obscureText: true,
                  ),
                ],
              ),
              SizedBox(height: (screenSize.height * 0.15)),
              Button(
                text: "Sign Up",
                onPressed: () => {print("signUp")},
                width: WidthOfFields,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _SignUp() async {
    String UserName = this.fullName;
    String EmailId = this.email;
    String Password = this.password;
  }

  Widget inputField({
    required String hintText,
    required IconData prefixIcon,
    required Function(String) onChanged,
    double? width,
    double? height,
    bool obscureText = false,
  }) {
    return Container(
      width: width ?? 400,
      height: height ?? 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: Colors.white),
        color: Color.fromRGBO(248, 240, 229, 1.0),
      ),
      child: TextField(
        onChanged: onChanged,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
          hintStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
