import 'package:flutter/material.dart';
import 'package:contactus/contactus.dart';
import 'package:google_fonts/google_fonts.dart'; // Import for using Jockey One font

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: GoogleFonts.jockeyOne(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 109, 40, 217),
      ),
      body: ContactUs(
        cardColor: Color.fromARGB(255, 255, 255, 255),
        textColor: const Color.fromARGB(255, 109, 40, 217),
        logo: null, // Remove the image
        email: 'yourapp@example.com',
        companyName: 'Chit Chat',
        companyColor: Colors.white,
        phoneNumber: '+1234567890',
        website: 'https://yourcompanywebsite.com',
        linkedinURL: 'https://linkedin.com/company/yourcompany',
        tagLine: 'We are here to help you!',
        taglineColor: Colors.white,
        instagram: 'your_instagram',
        facebookHandle: 'your_facebook_handle',
        twitterHandle: 'your_twitter_handle',
        githubUserName: 'your_github_username',
        textFont: GoogleFonts.jockeyOne().fontFamily, // Set font to Jockey One
        companyFont:
            GoogleFonts.jockeyOne().fontFamily, // Set font to Jockey One
        taglineFont:
            GoogleFonts.jockeyOne().fontFamily, // Set font to Jockey One
        dividerColor: Colors.white70,
      ),
    );
  }
}
