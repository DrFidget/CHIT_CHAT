import 'package:flutter/material.dart';

class ChatMessage {
  final String profilePicUrl;
  final String name;
  final String email;
  final DateTime timestamp;

  ChatMessage({
    required this.profilePicUrl,
    required this.name,
    required this.email,
    required this.timestamp,
  });
}

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage chatMessage;

  const ChatMessageWidget({Key? key, required this.chatMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedTimestamp;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(chatMessage.timestamp.year,
        chatMessage.timestamp.month, chatMessage.timestamp.day);

    if (today == messageDate) {
      formattedTimestamp =
          '${chatMessage.timestamp.hour}:${chatMessage.timestamp.minute}';
    } else {
      formattedTimestamp =
          '${chatMessage.timestamp.day}/${chatMessage.timestamp.month}/${chatMessage.timestamp.year}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(chatMessage.profilePicUrl),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatMessage.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      chatMessage.email,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Spacer(), // Added Spacer widget
                    Text(
                      formattedTimestamp,
                      style: TextStyle(
                        color: Colors.black,
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
    );
  }
}
