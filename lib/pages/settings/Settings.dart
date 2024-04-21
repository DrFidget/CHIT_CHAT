import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:ourappfyp/types/UserClass.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final userBox = Hive.box<UserClass>('userBox');
  List<UserClass> userDataList = [];
  final firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    readData();
  }

  void readData() {
    userDataList = userBox.values.toList();
  }

  Future<bool> checkEmailExistsInFirestore(String email) async {
    QuerySnapshot query = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return query.docs.isNotEmpty;
  }

  Future<void> updateEmailAndPassword(
      String? oldEmail, String newEmail, String newPassword) async {
    UserClass user =
        userBox.values.firstWhere((element) => element.email == oldEmail);
    user.email = newEmail;
    user.password = newPassword;
    userBox.add(user);

    await firestore
        .collection('users')
        .where('email', isEqualTo: oldEmail)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({
          'email': newEmail,
          'password': newPassword,
        });
      });
    });

    setState(() {
      // Update UI if necessary
    });
  }

  Future<void> showUpdateDialog(String oldEmail) async {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Email and Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'New Email'),
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'New Password'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newEmail = emailController.text.trim();
                String newPassword = passwordController.text.trim();
                if (newEmail.isNotEmpty && newPassword.isNotEmpty) {
                  bool emailExists =
                      await checkEmailExistsInFirestore(newEmail);
                  if (emailExists) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Email already exists.'),
                    ));
                  } else {
                    updateEmailAndPassword(oldEmail, newEmail, newPassword);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Email and password updated successfully.'),
                    ));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please enter both email and password.'),
                  ));
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 7, 18, 1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: AppBar(
          backgroundColor: Color.fromRGBO(109, 40, 217, 1),
          title: Text(
            "Settings",
            style: GoogleFonts.jockeyOne(
              textStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 32,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: userDataList.length,
              itemBuilder: (context, index) {
                final user = userDataList[index];
                return ListTile(
                  title: Text('Email: ${user.email}'),
                  subtitle: Text('Password: ${user.password}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/man.jpg'),
                  radius: 30,
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alex',
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      'Hi Its Alex',
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: Colors.white),
          Expanded(
            child: ListView(
              children: [
                _buildSettingsOption(
                  icon: Icons.key,
                  title: 'Account',
                  description:
                      'Security notifications, change number, delete account',
                  onTap: () {
                    String? oldEmail = userDataList.isNotEmpty
                        ? userDataList.first.email
                        : null;
                    showUpdateDialog(oldEmail!);
                  },
                ),
                // Other settings options...
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required String description,
    required Function onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 20, 10),
      child: InkWell(
        onTap: () => onTap(),
        child: Row(
          children: [
            if (title == 'Account')
              Transform.rotate(
                angle: 1.5708,
                child: Icon(
                  icon,
                  color: Color.fromRGBO(109, 40, 217, 1),
                  size: 30,
                ),
              )
            else
              Icon(
                icon,
                color: Color.fromRGBO(109, 40, 217, 1),
                size: 30,
              ),
            SizedBox(width: 35),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.jockeyOne(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (description.isNotEmpty)
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
