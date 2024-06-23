import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;

// Import your services and other dependencies as needed
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
  Uint8List? _image;
  late String userId = '';

  @override
  void initState() {
    super.initState();
    _getUserID();
  }

  // Method to fetch user ID from local storage using Hive
  void _getUserID() async {
    try {
      final _myBox = await Hive.openBox<UserClass>('userBox');
      final UserClass? user = await _myBox.get(1);

      if (user != null) {
        setState(() {
          userId = user.ID as String;
          print("Logged in user ID is -> $userId");
          _checkUser(userId); // Fetch user details from Firestore
        });
      } else {
        print("User ID Not Found");
      }
    } catch (error) {
      print('Error fetching user ID: $error');
    }
  }

  // Method to retrieve user details from Firestore based on user ID
  void _checkUser(String userId) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      DocumentSnapshot userSnapshot = await users.doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        setState(() {
          nameController.text = userData['name'] ?? '';
          emailController.text = userData['email'] ?? '';
          String imageLink =
              userData['profileImageUrl'] ?? ''; // Retrieve imageLink
          if (imageLink.isNotEmpty) {
            // Load image from Firebase Storage
            firebase_storage.FirebaseStorage storage =
                firebase_storage.FirebaseStorage.instance;
            firebase_storage.Reference ref = storage.ref().child(imageLink);
            ref.getDownloadURL().then((url) {
              setState(() {
                _image = null; // Clear previously selected image
                _displayImageFromNetwork(url);
              });
            }).catchError((e) {
              print('Error loading profile image: $e');
            });
          }
        });
      } else {
        print('User not found in Firestore');
      }
    } catch (error) {
      print('Error retrieving user details: $error');
    }
  }

  // Method to fetch image from network and update _image state
  void _displayImageFromNetwork(String imageUrl) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      setState(() {
        _image = response.bodyBytes;
      });
    } else {
      print('Error fetching image from network');
    }
  }

  // Method to select an image from gallery using ImagePicker
  void _selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  // Method to upload selected image to Firebase Storage and return download URL
  Future<String> uploadImageToStorage(Uint8List image) async {
    try {
      ImageServiceFirestore imageService = ImageServiceFirestore();
      String? imageUrl = await imageService.uploadImage(image);
      // Handle null case if imageUrl is null
      if (imageUrl != null) {
        return imageUrl; // Return non-null value
      } else {
        throw 'Failed to upload image'; // Handle error or return default URL
      }
    } catch (error) {
      print('Error uploading image to Firebase Storage: $error');
      return ''; // Return default value or handle error case
    }
  }

  // Method to update user data in Firestore with name, email, and optional image URL
  Future<void> updateUserData(
      String name, String email, String? imageLink) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      await users.doc(userId).update({
        'name': name,
        'email': email,
        if (imageLink != null) 'profileImageUrl': imageLink,
      });

      print('User data updated successfully!');
    } catch (error) {
      print('Error updating user data: $error');
    }
  }

  // Method to save profile changes (name, email, and optionally image)
  void _saveProfile() async {
    String name = nameController.text;
    String email = emailController.text;
    final UserService = UserFirestoreService();
    try {
      String? imageLink;
      if (_image != null) {
        imageLink = await uploadImageToStorage(_image!);
      }
      await UserService.updateUserCredentials(userId, name, email, imageLink);

      // Navigate back to main dashboard after saving profile
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AppStructure()),
      );
    } catch (error) {
      print('Error saving profile: $error');
    }
  }

  // Build method for the profile screen UI
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
            Navigator.pop(context); // Navigate back to previous screen
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
                        _image != null
                            ? CircleAvatar(
                                radius: 65.0,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : CircleAvatar(
                                radius: 65.0,
                                backgroundImage: AssetImage(
                                  'assets/avatar.jpg', // Placeholder image
                                ),
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
                              onPressed: () {
                                _selectImage(); // Open image picker
                              },
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
                onPressed: _saveProfile, // Save profile changes
                child: const Text(
                  'Save Profile',
                ),
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

  // Widget to build each profile field (name, email)
  Widget _buildProfileField(String label, IconData icon, String hint,
      TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Add your edit functionality here
            },
          ),
        ],
      ),
    );
  }
}
