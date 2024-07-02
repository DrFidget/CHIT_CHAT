import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:ourappfyp/services/HiveBoxService/HiveService.dart';
import 'package:ourappfyp/services/ImageServiceFireStore/ImageService.dart';
import 'package:ourappfyp/services/UserCollectionFireStore/usersCollection.dart';
import 'package:ourappfyp/utils.dart';
import 'package:ourappfyp/types/UserClass.dart';
import 'package:ourappfyp/pages/MainDashboard/MainAppStructureDashBoard.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  UserClass? user;
  String? _image;
  String userId = '';

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    try {
      final hiveService = HiveService();
      user = await hiveService.getUser();
      if (user != null) {
        setState(() {
          userId = user!.ID!;
          _image = user?.imageLink;
          nameController.text = user!.name!;
          emailController.text = user!.email!;
        });
        _checkUser(userId);
      } else {
        print("User not found in local storage.");
      }
    } catch (error) {
      print('Error fetching user: $error');
    }
  }

  void _checkUser(String userId) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      DocumentSnapshot userSnapshot = await users.doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        setState(() {
          // Optional: Update other user details if needed
        });
      } else {
        print('User not found in Firestore');
      }
    } catch (error) {
      print('Error retrieving user details: $error');
    }
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      Uint8List imageBytes = await imageFile.readAsBytes();
      String base64String = base64Encode(imageBytes);
      setState(() {
        _image = base64String;
      });
    }
  }

  Future<String> uploadImageToStorage(String base64String) async {
    try {
      ImageServiceFirestore imageService = ImageServiceFirestore();
      String? imageUrl = await imageService.uploadImage(base64String);
      if (imageUrl != null) {
        return imageUrl;
      } else {
        throw 'Failed to upload image';
      }
    } catch (error) {
      print('Error uploading image to Firebase Storage: $error');
      return '';
    }
  }

  Future<void> _saveProfile() async {
    String name = nameController.text;
    String email = emailController.text;
    final userService = UserFirestoreService();
    try {
      String? imageLink;
      if (_image != null) {
        if (_image!.startsWith('http')) {
          imageLink = _image;
        } else {
          imageLink = await uploadImageToStorage(_image!);
        }
      }
      await userService.updateUserCredentials(userId, name, email, imageLink);
      if (user != null) {
        user!.name = name;
        user!.email = email;
        user!.imageLink = imageLink;
        final hiveService = HiveService();
        await hiveService.updateUser(user!);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AppStructure()),
      );
    } catch (error) {
      print('Error saving profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Color appBarColor = const Color.fromRGBO(109, 40, 217, 1);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Profile",
          style: GoogleFonts.jockeyOne(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 28,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30.0),
              Stack(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 65.0,
                          backgroundImage: _image != null
                              ? (_image!.startsWith('http')
                                      ? NetworkImage(_image!)
                                      : MemoryImage(base64Decode(_image!)))
                                  as ImageProvider
                              : AssetImage('assets/avatar.jpg'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: appBarColor,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.add_a_photo),
                              color: Colors.black,
                              onPressed: _selectImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildProfileField(
                  "Name", Icons.person, "Enter Name", nameController),
              SizedBox(height: 20),
              _buildProfileField(
                  "Email", Icons.info, "Enter Email", emailController),
              SizedBox(height: 45),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save Profile'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(appBarColor),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, IconData icon, String hint,
      TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color.fromARGB(255, 141, 141, 141), size: 23),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 141, 141, 141),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
