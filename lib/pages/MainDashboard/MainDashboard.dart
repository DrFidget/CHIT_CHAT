import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ourappfyp/Components/ListItemComponent.dart';
import 'package:ourappfyp/Components/Message.dart';
import 'package:ourappfyp/pages/MainDashboard/ChatRoomListScreen.dart';

class MainDashBoard extends StatefulWidget {
  const MainDashBoard({Key? key}) : super(key: key);

  @override
  State<MainDashBoard> createState() => _MainDashBoardState();
}

class _MainDashBoardState extends State<MainDashBoard> {
  @override
  Widget build(BuildContext context) {
    return ChatRoomListScreen(loggedInUserId: "22KDDtL7ebpFluEyXOKE");
    // return Scaffold(
    //   backgroundColor: Color.fromARGB(1, 3, 7, 18),
    //   appBar: AppBar(
    //     backgroundColor: Color.fromARGB(1, 3, 7, 18),
    //     centerTitle: true,
    //     title: Text(
    //       'User List',
    //       style: TextStyle(
    //         color: Colors.white,
    //         fontWeight: FontWeight.bold,
    //         fontSize: 30,
    //       ),
    //     ),
    //   ),
    //   body: SingleChildScrollView(
    //     child: StreamBuilder<QuerySnapshot>(
    //       stream: FirebaseFirestore.instance.collection('users').snapshots(),
    //       builder: (context, snapshot) {
    //         if (snapshot.connectionState == ConnectionState.waiting) {
    //           return Center(child: CircularProgressIndicator());
    //         }

    //         if (snapshot.hasError) {
    //           return Center(child: Text('Error: ${snapshot.error}'));
    //         }

    //         List<DocumentSnapshot> users = snapshot.data!.docs;

    //         return ListView.builder(
    //           shrinkWrap: true,
    //           physics: NeverScrollableScrollPhysics(),
    //           itemCount: users.length,
    //           itemBuilder: (context, index) {
    //             var user = users[index];
    //             return ListItemComponent(
    //               backgroundColor: Colors.purple,
    //               widthPercent: .7,
    //               text: user['name'],
    //               callback: () => {}, // Placeholder callback
    //             );
    //           },
    //         );
    //       },
    //     ),
    //   ),
    // );
  }
}
