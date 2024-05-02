import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourappfyp/Components/Button.dart';
import 'package:ourappfyp/services/UserCollectionFireStore/usersCollection.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late String fullName;
  late String Email;
  late String Password;
  final FireStoreService = UserFirestoreService();
  bool _isLoading = false;
  String _errorMessage = '';
  // final TextEditingController email = TextEditingController();
  // final TextEditingController password = TextEditingController();

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
                    'Create Account Now!',
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
                        Email = value;
                      });
                      // print(fullName);
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
                        Password = value;
                      });
                      // print(fullName);
                    },
                  ),
                ],
              ),
              SizedBox(height: (screenSize.height * 0.08)),
              Button(
                text: "Sign Up",
                onPressed: _SignUp,
                width: WidthOfFields,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _SignUp() async {
    String emailValue = Email;
    String passwordValue = Password;
    String fullnameValue = fullName;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      showDialog(
        context: context,
        barrierDismissible:
            false, // Prevent dialog from being dismissed by tapping outside
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailValue,
        password: passwordValue,
      );

      try {
        await FireStoreService.addUser(
            fullnameValue, emailValue, passwordValue);
      } catch (e) {
        print(e);
      }

      Navigator.pop(context); // Dismiss loading dialog

      Navigator.pushReplacementNamed(context, '/callScreen');
    } catch (e) {
      setState(() {
        _errorMessage =
            '${e.toString()}. Please check your credentials and try again!';
        _isLoading = false;
      });

      Navigator.pop(context); // Dismiss loading dialog

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage),
        ),
      );
    }
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
//https://www.youtube.com/watch?v=rWamixHIKmQ&ab_channel=FlutterMapp