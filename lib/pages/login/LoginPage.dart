import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ourappfyp/Components/Button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourappfyp/services/UserCollectionFireStore/usersCollection.dart';
import 'package:ourappfyp/types/UserClass.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String _email;
  late String _password;
  final UserFirestoreService userFirestoreService = UserFirestoreService();
  bool _rememberMe = false;
  bool _isLoading = false;
  late String _errorMessage = '';

  void printData(String email) async {}

  @override
  void initState() {
    super.initState();
    _email = '';
    _password = '';
  }

  void _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      WriteData();

      Navigator.pop(context); // Dismiss loading dialog
      Navigator.pushReplacementNamed(context, '/Settings');
    } on FirebaseAuthException catch (e) {
      String errorMessage =
          'An unexpected error occurred, please try again later.';

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Invalid password.';
          break;
      }

      setState(() {
        _errorMessage = errorMessage;
        _isLoading = false;
      });

      Navigator.pop(context); // Dismiss loading dialog
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred, please try again later.';
        _isLoading = false;
      });

      Navigator.pop(context); // Dismiss loading dialog
    }
  }

  // void _signIn() async {
  //   setState(() {
  //     _isLoading = true;
  //     _errorMessage = '';
  //   });

  //   try {
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Center(child: CircularProgressIndicator());
  //       },
  //     );

  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: _email,
  //       password: _password,
  //     );

  //     WriteData();

  //     Navigator.pop(context); // Dismiss loading dialog
  //     Navigator.pushReplacementNamed(context, '/Settings');
  //   } on FirebaseAuthException catch (e) {
  //     String errorMessage =
  //         'An unexpected error occurred, please try again later.';

  //     switch (e.code) {
  //       case 'user-not-found':
  //         errorMessage = 'No user found with this email.';
  //         break;
  //       case 'wrong-password':
  //         errorMessage = 'Invalid password.';
  //         break;
  //     }

  //     setState(() {
  //       _errorMessage = errorMessage;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _errorMessage = 'An unexpected error occurred, please try again later.';
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double verticalSpacing = screenSize.height * 0.05;
    final double widthOfFields = screenSize.width * 0.8;

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
                    width: widthOfFields,
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
                    width: widthOfFields,
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
                width: widthOfFields,
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
                onPressed: _isLoading ? () {} : _signIn,
                // onPressed: _isLoading ? null : _signIn!,
                width: widthOfFields,
              ),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
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

  void WriteData() async {
    print("++++++++++++++++++++++++++++++++++++++++++++");
    try {
      UserClass? user = await userFirestoreService.getUserByEmail(_email);
      if (user != null) {
        final _myBox = Hive.box<UserClass>('userBox');
        try {
          await _myBox.put(1, user);
          print("------------------LOCAL-STORAGE--------------------");
          final x = await _myBox.get(1);
          print(x?.name);
          print(x?.email);
          print(x?.password);
          print(x?.ID);
          print(x?.timeStamp);
          print("--------------------------------------");
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
    print("++++++++++++++++++++++++++++++++++++++++++++");
    // final _myBox = Hive.box<UserClass>('userBox');
  }
}
