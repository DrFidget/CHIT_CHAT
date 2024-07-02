import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBoxDisplay {
  final String profilePicUrl;
  final String name;
  final String email;
  final DateTime timestamp;
  final VoidCallback onTap;

  ChatBoxDisplay({
    required this.profilePicUrl,
    required this.name,
    required this.email,
    required this.timestamp,
    required this.onTap,
  });
}

class ChatBoxDisplayWidget extends StatelessWidget {
  final ChatBoxDisplay chatMessage;

  const ChatBoxDisplayWidget({Key? key, required this.chatMessage})
      : super(key: key);

  String formattedTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate =
        DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (today == messageDate) {
      return '${timestamp.hour}:${timestamp.minute}';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: chatMessage.onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 60,
          minWidth: double.infinity,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                child: ClipOval(
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/avatar.jpg',
                    image: chatMessage.profilePicUrl,
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chatMessage.name,
                              style: GoogleFonts.jockeyOne(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              chatMessage.email,
                              style: GoogleFonts.jockeyOne(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          formattedTimestamp(chatMessage.timestamp),
                          style: GoogleFonts.jockeyOne(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
