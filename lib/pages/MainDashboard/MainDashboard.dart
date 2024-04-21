import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:ourappfyp/Components/ListItemComponent.dart';
import 'package:ourappfyp/Components/Message.dart';
import 'package:ourappfyp/pages/MainDashboard/ChatRoomListScreen.dart';
import 'package:ourappfyp/types/UserClass.dart';

class MainDashBoard extends StatefulWidget {
  const MainDashBoard({Key? key}) : super(key: key);

  @override
  State<MainDashBoard> createState() => _MainDashBoardState();
}

class _MainDashBoardState extends State<MainDashBoard> {
  late String loggedInUserId = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Retrieve user ID from local storage (Hive)
    getUserFromLocalStorage();
  }

  void getUserFromLocalStorage() async {
    try {
      final _myBox = await Hive.openBox<UserClass>('userBox');
      final UserClass? user = _myBox.get(1);
      if (user != null) {
        setState(() {
          loggedInUserId = user.ID as String;
          isLoading = false; // Set loading to false once user data is retrieved
        });
      } else {
        setState(() {
          isLoading =
              false; // Set loading to false even if user data is not found
        });
        // Handle case where user data is not found in local storage
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Set loading to false if an exception occurs
      });
      // Handle exceptions while accessing local storage
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator() // Show loading indicator while fetching user data
        : loggedInUserId.isNotEmpty
            ? ChatRoomListScreen(loggedInUserId: loggedInUserId)
            : Container(); // Placeholder in case user data is empty
    // return ChatRoomListScreen(loggedInUserId: "22KDDtL7ebpFluEyXOKE");
  }
}
