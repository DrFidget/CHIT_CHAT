import 'package:flutter/material.dart';

enum CallType { missed, received, outgoing }

class UserCallInfo extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String profilePicUrl;
  final CallType callType;
  final String timestamp;

  const UserCallInfo({
    Key? key,
    required this.name,
    required this.phoneNumber,
    required this.profilePicUrl,
    required this.callType,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData callIcon;
    Color? callIconColor;
    String callTypeText;

    switch (callType) {
      case CallType.missed:
        callIcon = Icons.call_missed;
        callIconColor = Colors.red;
        callTypeText = 'Missed Call';
        break;
      case CallType.received:
        callIcon = Icons.call_received;
        callIconColor = Colors.green;
        callTypeText = 'Received Call';
        break;
      case CallType.outgoing:
        callIcon = Icons.call_made;
        callIconColor = Colors.blue;
        callTypeText = 'Outgoing Call';
        break;
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(profilePicUrl),
            radius: 30,
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      callIcon,
                      color: callIconColor,
                    ),
                    SizedBox(width: 8.0),
                    SizedBox(
                      width: 100.0, // Fixed width for call type text
                      child: Text(
                        callTypeText,
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8), // Add some spacing between rows
                Row(
                  children: [
                    Text(phoneNumber, style: TextStyle(color: Colors.white)),
                    SizedBox(width:100),
                    // Spacer(), // Occupy the remaining space
                    Text(timestamp, style: TextStyle(color: Colors.white)),
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



