import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromRGBO(3, 7, 18, 1),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(75), // Set the height of the AppBar
          child: AppBar(
            backgroundColor: Color.fromRGBO(109, 40, 217, 1),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Add your search functionality here
                },
              ),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/man.jpg'),
                    // Replace with user's profile picture
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
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        'Hi Its Alex',
                        style: GoogleFonts.interTight(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white), // Line separator
            Expanded(

              child: ListView(
                children: [

                  _buildSettingsOption(
                    icon: Icons.key,
                    title: 'Account',
                    description: 'Security notifications, change number, delete account',

                  ),
                  _buildSettingsOption(
                    icon: Icons.lock,
                    title: 'Privacy',
                    description: 'Manage your privacy settings',
                  ),
                  _buildSettingsOption(
                    icon: Icons.chat,
                    title: 'Chat',
                    description: 'Manage your chat settings',
                  ),
                  _buildSettingsOption(
                    icon: Icons.notifications,
                    title: 'Notification',
                    description: 'Manage your notification settings',
                  ),
                  _buildSettingsOption(
                    icon: Icons.language,
                    title: 'App Language',
                    description: 'Choose your preferred language',
                  ),
                  _buildSettingsOption(
                    icon: Icons.help,
                    title: 'Help',
                    description: 'Get help and support',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 20, 10),
      child: Row(
        children: [
          if (title ==
              'Account') // Only rotate the icon if the title is 'Account'
            Transform.rotate(
              angle: 1.5708, // 90 degrees in radians
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
                Text(
                  description,
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}