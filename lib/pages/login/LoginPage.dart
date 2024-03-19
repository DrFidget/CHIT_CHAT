import 'package:flutter/material.dart';
import 'package:ourappfyp/Components/Button.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;

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
                  const SizedBox(height: 5),
                  Text(
                    'Login to continue',
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  const Text(
                    'User ID',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  inputField(
                    hintText: 'Enter your username',
                    prefixIcon: Icons.person,
                    width: WidthOfFields,
                    onChanged: (value) {
                      // Handle username onChanged
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
                      // Handle password onChanged
                    },
                    obscureText: true,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                margin: EdgeInsets.only(left: 32),
                width: WidthOfFields,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            value: _rememberMe,
                            fillColor: MaterialStateProperty.all(
                              Color.fromRGBO(248, 240, 229, 1.0),
                            ),
                            onChanged: (v) => {
                                  setState(() {
                                    _rememberMe = !_rememberMe;
                                  })
                                }),
                        const Text(
                          'Remember Me',
                          style: TextStyle(color: Colors.white, fontSize: 13.0),
                        ),
                      ],
                    ),
                    TextButton(
                        onPressed: () => {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.white, fontSize: 13.0),
                        ))
                  ],
                ),
              ),
              SizedBox(height: 35),
              Button(
                text: "Login",
                onPressed: () => {},
                width: WidthOfFields,
              ),
              SizedBox(height: 10),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to signup page
                        // Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color.fromRGBO(109, 40, 217, 1.0),
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                          decorationColor: Color.fromRGBO(109, 40, 217, 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
