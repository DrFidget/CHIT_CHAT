import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourappfyp/pages/call/CallScreen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedIndex = 0;

  // Sample messages
  static const List<String> sampleMessages = [
    'How are you?',
    'Hello!',
    'What\'s up?',
    'Good morning!',
    'Nice to meet you.',
    'How can I help you?',
    'I\'m fine, thank you.',
    'This is a test message.',
    'Have a great day!',
    'Is everything okay?',
  ];

  // Sample names
  static const List<String> sampleNames = [
    'John',
    'Alice',
    'Bob',
    'Emma',
    'David',
    'Olivia',
    'Michael',
    'Sophia',
    'Daniel',
    'Emily',
  ];

  // Function to get a random message
  String getRandomMessage() {
    final Random random = Random();
    return sampleMessages[random.nextInt(sampleMessages.length)];
  }

  // Function to get a random name
  String getRandomName() {
    final Random random = Random();
    return sampleNames[random.nextInt(sampleNames.length)];
  }

  // Function to generate different times for each sender
  String getTime(int index) {
    final DateTime now = DateTime.now();
    final Random random = Random();
    final int hoursAgo = random.nextInt(24);
    final DateTime messageTime = now.subtract(Duration(hours: hoursAgo));

    if (index == 2) {
      // Set time for the 3rd sender to yesterday
      return 'Yesterday';
    } else {
      // Set random time for other senders
      return '${messageTime.hour}:${messageTime.minute} ${messageTime.hour >= 12 ? 'PM' : 'AM'}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double appBarVerticalPadding = appBarHeight * 0.35;
    final double appBarHeightTotal =
        appBarHeight + statusBarHeight + appBarVerticalPadding * 3;

    // Calculate search box height dynamically
    final double searchBoxHeight = (screenHeight * 0.05).clamp(40.0, 60.0);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(3, 7, 18, 1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeightTotal),
        child: AppBar(
          backgroundColor: const Color.fromRGBO(109, 40, 217, 1),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // Handle back button press
              Navigator.pushNamed(context, '/');
            },
          ),
          title: Text(
            "ChitChat",
            style: GoogleFonts.jockeyOne(
              textStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 28,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
              onPressed: () {
                // Add camera functionality here
              },
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: "New group",
                  child: Text("New group"),
                ),
                const PopupMenuItem(
                  value: "New broadcast",
                  child: Text("New broadcast"),
                ),
                const PopupMenuItem(
                  value: "WhatsApp Web",
                  child: Text("WhatsApp Web"),
                ),
                const PopupMenuItem(
                  value: "Starred messages",
                  child: Text("Starred messages"),
                ),
                const PopupMenuItem(
                  value: "Settings",
                  child: Text("Settings"),
                ),
              ],
              onSelected: (value) {
                // Handle item selection
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8), // Adjusted top margin
                  Container(
                    height: searchBoxHeight,
                    margin: const EdgeInsets.only(bottom: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const TextField(
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        hintText: "Search...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildTabItem(0, 'Chats'),
                      buildTabItem(1, 'Groups'),
                      buildTabItem(2, 'Calls'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with the actual number of messages
              itemBuilder: (context, index) {
                // You can use your own message model here
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person), // Placeholder for profile image
                  ),
                  title: Text(
                    getRandomName(),
                    style: const TextStyle(
                        color: Colors.white), // Set name text color to white
                  ),
                  subtitle: Row(
                    children: [
                      if (index == 3)
                        const Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.photo),
                        ),
                      Text(
                        index == 3 ? 'Photo' : getRandomMessage(),
                        style: const TextStyle(
                            color: Colors
                                .white), // Set message text color to white
                      ), // Display random message or "Photo" for the 4th sender
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        getTime(index),
                        style: const TextStyle(
                            color: Colors
                                .white), // Set timestamp text color to white
                      ),
                      const SizedBox(width: 5),
                      (index % 2 == 0)
                          ? const Icon(Icons.done_all, color: Colors.blue)
                          : const Icon(Icons.done,
                              color: Colors
                                  .red), // Conditionally display read/unread status icon
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector buildTabItem(int index, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CallScreen()),
            );
          }
          // Navigate to corresponding screen based on index
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color:
                  _selectedIndex == index ? Colors.white : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              color: _selectedIndex == index ? Colors.white : Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
