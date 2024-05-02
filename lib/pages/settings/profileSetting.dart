// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Setting background color to black
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Making app bar transparent
        elevation: 0, // Removing app bar elevation
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          color: Colors.purple,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligning items to the start and end
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              const SizedBox(width: 56.0), // Adding space to align text to the center
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            Stack(
              children: [
                CircleAvatar(
                  radius: 60.0,
                  backgroundColor: Colors.grey[400], // Fallback background color
                  child: const CircleAvatar(
                    radius: 57.0,
                    backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/75.jpg', // Random image of a person
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt),
                      color: Colors.white,
                      onPressed: () {
                        // Add camera functionality here
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            _buildProfileInfo(title: 'Name', value: 'John Doe'),
            _buildDivider(), // Divider below 'Name' section
            _buildProfileInfo(title: 'About', value: 'Hello, I am using WhatsApp!'),
            _buildDivider(), // Divider below 'About' section
            _buildProfileInfo(title: 'Phone', value: '+1234567890'),
            _buildDivider(), // Divider below 'Phone' section
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo({required String title, required String value}) {
    IconData icon;
    if (title == 'Name') {
      icon = Icons.person;
    } else if (title == 'About') {
      icon = Icons.info;
    } else if (title == 'Phone') {
      icon = Icons.phone;
    } else {
      icon = Icons.error; // Fallback icon
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 10.0),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.white, // Setting text color to white
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 10.0),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Add edit functionality here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      height: 1.0,
      color: Colors.grey[400], // Setting divider color to grey
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfileScreen(),
  ));
}
