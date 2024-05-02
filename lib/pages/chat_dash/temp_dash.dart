import 'package:flutter/material.dart';
import 'package:ourappfyp/pages/chat_dash/chat_info.dart';

class Dashboard_Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Demo'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ChatMessageWidget(
              chatMessage: ChatMessage(
                profilePicUrl: 'https://example.com/profile_pic.jpg',
                name: 'John Doe',
                email: 'john.doe@example.com',
                // message: 'Hello, how are you?',
                timestamp: DateTime.now(),
              ),
            ),
            ChatMessageWidget(
              chatMessage: ChatMessage(
                profilePicUrl: 'https://example.com/another_profile_pic.jpg',
                name: 'Jane Smith',
                email: 'jane.smith@example.com',
                // message: 'I\'m doing fine, thank you!',
                timestamp: DateTime.now(),
              ),
            ),
            // Add more ChatMessageWidget instances as needed
          ],
        ),
      ),
    );
  }
}
