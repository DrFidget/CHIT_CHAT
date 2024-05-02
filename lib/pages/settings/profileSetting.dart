import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourappfyp/utils.dart';
import 'package:ourappfyp/resources/add_data.dart';
import 'package:ourappfyp/pages/chat_dash/temp_dash.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void saveProfile() async {
    String name = nameController.text;
    String email = nameController.text;

    String resp =
        await storeData().saveData(name: name, email: email, file: _image!);

    // Navigate to the main dashboard page after saving profile
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Dashboard_Page()),
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
                                selectImage();
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
                  "Name", Icons.person, "John Doe", nameController),
              SizedBox(height: 20),
              _buildProfileField(
                  "Email", Icons.info, "johndoe@test.com", emailController),
              SizedBox(height: 20),
              _buildProfileField(
                  "Phone", Icons.phone, "+1234567890", phoneController),
              SizedBox(height: 45),
              ElevatedButton(
                onPressed: saveProfile,
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

  Widget _buildProfileField(String label, IconData icon, String value,
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
                    hintText: value,
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
