import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageSettingsPage extends StatefulWidget {
  @override
  _LanguageSettingsPageState createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'ur', 'name': 'Urdu'},
    // Add more languages as needed
  ];

  String? _selectedAppLanguage;
  String? _selectedSpeechLanguage;
  String? _selectedTranslationLanguage;

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
            _buildDropdown(context, 'App Language', _selectedAppLanguage,
                (value) => setState(() => _selectedAppLanguage = value)),
            SizedBox(height: 20),
            Divider(
                color: Colors.white), // Use white color divider for contrast
            SizedBox(height: 20),
            _buildDropdown(
                context,
                'Default Speech Language',
                _selectedSpeechLanguage,
                (value) => setState(() => _selectedSpeechLanguage = value)),
            SizedBox(height: 20),
            Divider(
                color: Colors.white), // Use white color divider for contrast
            SizedBox(height: 20),
            _buildDropdown(
                context,
                'Default Translation Language',
                _selectedTranslationLanguage,
                (value) =>
                    setState(() => _selectedTranslationLanguage = value)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(BuildContext context, String title,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.jockeyOne(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: selectedValue,
          onChanged: onChanged,
          items: languages.map((language) {
            return DropdownMenuItem<String>(
              value: language['code'],
              child: Text(
                language['name']!,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          dropdownColor: Colors.white,
          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}
