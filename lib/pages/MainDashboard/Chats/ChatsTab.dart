import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:ourappfyp/pages/MainDashboard/Chats/DisplayAllChats.dart';
import 'package:ourappfyp/pages/MainDashboard/Chats/DisplayAllUsers.dart';
import 'package:ourappfyp/services/ChatBoxCollectionFireStore/chatCollection.dart';
import 'package:ourappfyp/services/UserCollectionFireStore/usersCollection.dart';
import 'package:ourappfyp/types/UserClass.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({super.key});

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
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
      final UserClass? user = _myBox.get(1);
      if (user != null) {
        setState(() {
          loggedInUserId = user.ID as String;
          print(loggedInUserId);
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
      body: isLoading
          ? const CircularProgressIndicator()
          : Stack(
              children: [
                DisplayAllChatsWithUsers(loggedInUserId, chatRoomServices),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAllUsers(context, userServices, loggedInUserId),
        child: const Icon(Icons.add),
      ),
    );
  }
}
