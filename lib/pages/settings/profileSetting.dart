import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourappfyp/utils.dart';
import 'package:ourappfyp/types/UserClass.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:ourappfyp/pages/MainDashboard/MainAppStructureDashBoard.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  // final TextEditingController phoneController = TextEditingController();
  Uint8List? _image;
  late String userId = '';

  @override
  void initState() {
    super.initState();
    _getUserID();
  }

  void _checkUser(String userId) async {
    try {
      // Reference to the Firestore collection
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Get user document based on the user ID
      DocumentSnapshot userSnapshot = await users.doc(userId).get();

      if (userSnapshot.exists) {
        // Extract user data from the document
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        // Set user details to the corresponding text fields
        setState(() {
          nameController.text = userData['name'] ?? '';
          emailController.text = userData['email'] ?? '';
          // phoneController.text = userData['phone'] ?? '';
        });

        // You need to implement image handling as per your application logic
      } else {
        print('User not found in Firestore');
      }
    } catch (error) {
      print('Error retrieving user details: $error');
    }
  }

  //GETTING USER ID FROM LOCAL STORAGE
  void _getUserID() async {
    final _myBox = await Hive.openBox<UserClass>('userBox');
    final UserClass? user = await _myBox.get(1);

    if (user != null) {
      setState(() {
        userId = user.ID as String;
        print("Logged in user ID is -> $userId");
        _checkUser(userId);
      });
    } else {
      print("User ID Not Found");
    }
  }

  void _selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future<String> uploadImageToStorage(Uint8List image) async {
    try {
      // Create a reference to the Firebase Storage bucket
      firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.ref();

      // Create a unique filename for the image
      String fileName =
          'profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload the image file to Firebase Storage
      await storageRef.child('profile_images/$fileName').putData(image);

      // Get the download URL of the uploaded image
      String downloadURL =
          await storageRef.child('profile_images/$fileName').getDownloadURL();

      // Return the download URL
      return downloadURL;
    } catch (error) {
      print('Error uploading image to Firebase Storage: $error');

      return '';
    }
  }

  Future<void> updateUserData(
      String name, String email, String? imageLink) async {
    try {
      // Reference to the Firestore collection
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Get reference to the user document
      DocumentReference userRef = users.doc(userId);

      // Create a map containing the updated user data
      Map<String, dynamic> userData = {
        'name': name,
        'email': email,
      };

      // Add imageUrl to userData if it's not null
      if (imageLink != null) {
        userData['imageLink'] = imageLink;
      }

      // Update user document in Firestore
      await userRef.update(userData);
    } catch (error) {
      print('Error updating user details: $error');
    }
  }

  void _saveProfile() async {
    String name = nameController.text;
    String email = emailController.text;

    // Check if image is changed
    if (_image != null) {
      // Upload image to Firebase Storage
      String imageLink = await uploadImageToStorage(_image!);

      // Update user details in Firestore with the new image URL
      await updateUserData(name, email, imageLink);
    } else {
      // Update user details in Firestore without changing the image URL
      await updateUserData(name, email, null);
    }

    // Navigate to the main dashboard page after saving profile
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AppStructure()),
    );
  }

  Color appBarColor = const Color.fromRGBO(109, 40, 217, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Changed from pushNamed to pop
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
                                  'assets/avatar.jpg', // Random image of a person
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
                                _selectImage();
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
              // SizedBox(height: 20),
              // _buildProfileField(
              //     "Phone", Icons.phone, "Enter Phone", phoneController),
              SizedBox(height: 45),
              ElevatedButton(
                onPressed: _saveProfile,
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
            icon: Icon(Icons.edit, color: appBarColor),
            onPressed: () {
              // Add your edit functionality here
            },
          ),
        ],
      ),
    );
  }
}
