import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourappfyp/Components/UserCallInfo.dart';
import 'package:ourappfyp/pages/chat_dash/chat.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key}) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  int _selectedIndex = 2;

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
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          title: Text(
            "ChitChat",
            style: GoogleFonts.jockeyOne(
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 28,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
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
            preferredSize: Size.fromHeight(0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 8), // Adjusted top margin
                  Container(
                    height: searchBoxHeight,
                    margin: const EdgeInsets.only(bottom: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: TextField(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserCallInfo(
              name: 'John Doe',
              phoneNumber: '+123-456-7890',
              profilePicUrl:
                  'https://i0.wp.com/eacademy.edu.vn/wp-content/uploads/2023/photos1/1/WhatsApp-DP-Cute-175.jpg?fit=928%2C1160&ssl=1', // Example placeholder image URL
              callType: CallType.missed,
              timestamp: '9:00 AM',
            ),
            UserCallInfo(
              name: 'Jane Smith',
              phoneNumber: '+987-654-3210',
              profilePicUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-HXPOrqk0Xh2iP9mzykc56h43VMgtIAXlWA&usqp=CAU', // Example placeholder image URL
              callType: CallType.outgoing,
              timestamp: '11:30 AM',
            ),
            UserCallInfo(
              name: 'Alice Johnson',
              phoneNumber: '+111-222-3333',
              profilePicUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8QBzahCYEdwzKa4RnTI3AJ1J261SrpSBAZA&usqp=CAU', // Example placeholder image URL
              callType: CallType.received,
              timestamp: '1:45 PM',
            ),
            UserCallInfo(
              name: 'Bob Williams',
              phoneNumber: '+444-555-6666',
              profilePicUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_OncQaOAG28bxsEaYnorYlfmB15IPShSbfg&usqp=CAU', // Example placeholder image URL
              callType: CallType.missed,
              timestamp: '3:20 PM',
            ),
            UserCallInfo(
              name: 'Alice Johnson',
              phoneNumber: '+111-222-3333',
              profilePicUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_S6vFF59KAagc1c2tVJEu_pupHS763T4mog&usqp=CAU', // Example placeholder image URL
              callType: CallType.outgoing,
              timestamp: '1:45 PM',
            ),
            UserCallInfo(
              name: 'Bob Williams',
              phoneNumber: '+444-555-6666',
              profilePicUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_wGmIhCT3dbe65Abb30IASkh7lS6fhiYeQA&usqp=CAU', // Example placeholder image URL
              callType: CallType.missed,
              timestamp: '3:20 PM',
            ),
            UserCallInfo(
              name: 'Alice Johnson',
              phoneNumber: '+111-222-3333',
              profilePicUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsmfERbRAo-HYTKP9GAGOduXnxd5rivD9q-Q&usqp=CAU', // Example placeholder image URL
              callType: CallType.received,
              timestamp: '1:45 PM',
            ),
            UserCallInfo(
              name: 'Bob Williams',
              phoneNumber: '+444-555-6666',
              profilePicUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSuFie48AoiZKZY7X1Vr-Dn4mKoEqBj6fy_kw&usqp=CAU', // Example placeholder image URL
              callType: CallType.missed,
              timestamp: '3:20 PM',
            ),
            // Add more UserCallInfo widgets as needed
          ],
        ),
      ),
    );
  }

  GestureDetector buildTabItem(int index, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          // Navigate to corresponding screen based on index
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
          }
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
