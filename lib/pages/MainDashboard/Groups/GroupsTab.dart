import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:ourappfyp/pages/MainDashboard/Groups/DisplayAllGroupChats.dart';
import 'package:ourappfyp/pages/MainDashboard/Chats/DisplayAllUsers.dart';
import 'package:ourappfyp/pages/MainDashboard/Groups/DisplayAllUsers/DisplayAllUser.dart';
import 'package:ourappfyp/services/ChatBoxCollectionFireStore/chatCollection.dart';
import 'package:ourappfyp/services/UserCollectionFireStore/usersCollection.dart';
import 'package:ourappfyp/types/UserClass.dart';

class GroupsTab extends StatefulWidget {
  const GroupsTab({super.key});

  @override
  State<GroupsTab> createState() => _GroupsTabState();
}

class _GroupsTabState extends State<GroupsTab> {
  late String loggedInUserId = '';
  bool isLoading = false;

  final UserFirestoreService userServices = UserFirestoreService();
  final chatBoxFirestoreService chatRoomServices = chatBoxFirestoreService();

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
          // print("logged in user id is ->${loggedInUserId} and name is ");
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 3, 7, 18),
      body: isLoading
          ? const CircularProgressIndicator()
          : Stack(
              children: [
                DisplayAllGroupChats(loggedInUserId, chatRoomServices),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            showAllGroupUsers(context, userServices, loggedInUserId),
        child: const Icon(Icons.add),
      ),
    );
  }
}
