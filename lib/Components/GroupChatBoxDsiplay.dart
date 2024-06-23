import 'package:flutter/material.dart';

class GroupChatBoxDisplay {
  final String groupPicUrl;
  final String groupName;
  final DateTime timestamp;
  final VoidCallback onTap;

  GroupChatBoxDisplay({
    required this.groupPicUrl,
    required this.groupName,
    required this.timestamp,
    required this.onTap,
  });
}

class GroupChatBoxDisplayWidget extends StatelessWidget {
  final GroupChatBoxDisplay groupChat;

  const GroupChatBoxDisplayWidget({Key? key, required this.groupChat})
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
      onTap: groupChat.onTap,
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
                backgroundImage: NetworkImage(groupChat.groupPicUrl),
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
                              groupChat.groupName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Text(
                          formattedTimestamp(groupChat.timestamp),
                          style: TextStyle(
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
