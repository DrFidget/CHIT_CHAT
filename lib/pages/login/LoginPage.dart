import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ourappfyp/Components/Button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourappfyp/types/UserClass.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String _email;
  late String _password;
  bool _rememberMe = false;
  final _myBox = Hive.box('userBox');

  void WriteData() async {
    print("++++++++++++++++++++++++++++++++++++++++++++");
    try {
      await _myBox.put(1, UserClass(email: _email, password: _password));
      print("------------------LOCAL-STORAGE--------------------");
      final UserClass x = await _myBox.get(1);
      print(x.name);
      print(x.email);
      print(x.password);
      print("--------------------------------------");
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _email = '';
    _password = '';
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double verticalSpacing = screenSize.height * 0.05;
    final double WidthOfFields = screenSize.width * 0.8;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(3, 7, 18, 1),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: verticalSpacing),
          child: Column(
            children: [
              AppBar(
                backgroundColor: const Color.fromRGBO(3, 7, 18, 1),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
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
                      setState(() {
                        _email = value;
                      });
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
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.only(left: 32),
                width: WidthOfFields,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            value: _rememberMe,
                            fillColor: MaterialStateProperty.all(
                              const Color.fromRGBO(109, 40, 217, 1.0),
                            ),
                            onChanged: (bool? value) {
                              setState(() {
                                _rememberMe = value ?? !_rememberMe;
                              });
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
              const SizedBox(height: 35),
              Button(
                text: "Login",
                onPressed: () => {_signIn()},
                width: WidthOfFields,
              ),
              const SizedBox(height: 10),
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
                        Navigator.pushNamed(context, '/register');
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
    double? width,
    double? height,
    bool obscureText = false,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      width: width ?? 400,
      height: height ?? 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: Colors.white),
        color: const Color.fromRGBO(248, 240, 229, 1.0),
      ),
      child: TextField(
        onChanged: onChanged,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
          hintStyle: const TextStyle(color: Colors.black),
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: this._email,
        password: this._password,
      );

      WriteData();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Signed In'),
            content: Text('SignIn successful'),
            actions: <Widget>[
              TextButton(
                  child: Text('Okay'),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/callScreen')),
            ],
          );
        },
      );
    } catch (e) {
      String errorMessage = 'An error occurred, please try again later.';

      // Check if the error is FirebaseAuthException
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found with this email.';
            break;
          case 'wrong-password':
            errorMessage = 'Invalid password.';
            break;
          default:
            errorMessage = 'Authentication failed. Please try again later.';
            break;
        }
      }

      // Show error dialog with appropriate message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
  }
}
