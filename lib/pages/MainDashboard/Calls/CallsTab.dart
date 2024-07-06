import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:ourappfyp/services/UserCollectionFireStore/usersCollection.dart';
import 'package:ourappfyp/types/UserClass.dart';
import 'package:ourappfyp/pages/MainDashboard/Calls/DisplayAllCalls';

class CallLogsTab extends StatefulWidget {
  const CallLogsTab({super.key});

  @override
  State<CallLogsTab> createState() => _CallLogsTabState();
}

class _CallLogsTabState extends State<CallLogsTab> {
  late String loggedInUserId = '';

  final UserFirestoreService userServices = UserFirestoreService();

  @override
  void initState() {
    super.initState();
    getUserFromLocalStorage();
  }

  void getUserFromLocalStorage() async {
    try {
      final _myBox = await Hive.openBox<UserClass>('userBox');
      final UserClass? user = await _myBox.get(1);
      if (user != null) {
        setState(() {
          loggedInUserId = user.ID as String;
        //  print("logged in user id is ->${loggedInUserId}");
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 7, 18),
      body: DisplayAllCallLogs(loggedInUserId),
    );
  }
}
