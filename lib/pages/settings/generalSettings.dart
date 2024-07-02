import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import for using Jockey One font

class GeneralSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 109, 40, 217),
        title: Text(
          'Settings',
          style: GoogleFonts.jockeyOne(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
            color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://example.com/profile.jpg'), // Replace with actual image URL
                    radius: 30,
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sarah',
                        style: GoogleFonts.jockeyOne(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        'Hi it\'s me Sarah',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white24),
            buildListTile(context, Icons.vpn_key, 'Account',
                'Security notifications, change number, delete account'),
            buildListTile(context, Icons.lock, 'Privacy',
                'Block contacts, change default privacy settings'),
            buildListTile(context, Icons.chat, 'Chats',
                'Theme, wallpapers, chat history'),
            buildListTile(context, Icons.notifications, 'Notifications',
                'Message, group and call tones'),
            buildListTile(context, Icons.language, 'App language',
                'English (phone\'s language)'),
            buildListTile(context, Icons.help, 'Help',
                'Help center, contact us, privacy policy'),
          ],
        ),
      ),
    );
  }

  ListTile buildListTile(
      BuildContext context, IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Color.fromARGB(255, 109, 40, 217)),
      title: Text(
        title,
        style: GoogleFonts.jockeyOne(
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.white70)),
      onTap: () {},
    );
  }
}
