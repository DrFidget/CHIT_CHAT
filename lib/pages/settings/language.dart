import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageSettingsPage extends StatelessWidget {
  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'ur', 'name': 'Urdu'},
    // Add more languages as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      backgroundColor: Colors.black, // Set the background color of the Scaffold
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildSectionTitle(context, 'App Language'),
            SizedBox(height: 20),
            Divider(
                color: Colors.white), // Use white color divider for contrast
            SizedBox(height: 20),
            _buildSectionTitle(context, 'Default Speech Language'),
            SizedBox(height: 20),
            Divider(
                color: Colors.white), // Use white color divider for contrast
            SizedBox(height: 20),
            _buildSectionTitle(context, 'Default Translation Language'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showLanguageOptions(BuildContext context, String sectionTitle) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSectionTitle(context, sectionTitle),
              SizedBox(height: 10),
              _buildLanguageList(context),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: languages.length,
      itemBuilder: (context, index) {
        final language = languages[index];
        return GestureDetector(
          onTap: () {
            // Implement logic to set selected language
            // For example, save to SharedPreferences and update UI
            Navigator.pop(context, language['code']);
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 109, 40, 217),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              language['name']!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        _showLanguageOptions(context, title);
      },
      child: Text(
        title,
        style: GoogleFonts.jockeyOne(
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
