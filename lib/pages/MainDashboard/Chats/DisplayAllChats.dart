import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ourappfyp/Components/chatBoxDisplay.dart';
import 'package:ourappfyp/pages/MainDashboard/ChatiingPage.dart';
import 'package:ourappfyp/pages/MainDashboard/Chats/messagingPage/MessagingPage.dart';
import 'package:ourappfyp/services/ChatBoxCollectionFireStore/chatCollection.dart';
import 'package:ourappfyp/services/UserCollectionFireStore/usersCollection.dart';
import 'package:ourappfyp/types/UserClass.dart';

Widget DisplayAllChatsWithUsers(
    String loggedInUserId, chatBoxFirestoreService chatServies) {
  final UserFirestoreService userServices = UserFirestoreService();

  return Column(
    children: [
      Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: chatServies.getChatRoomsOfLoggedInPerson(loggedInUserId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var chatRooms = snapshot.data!.docs;
              return ListView.builder(
                itemCount: chatRooms.length,
                itemBuilder: (context, index) {
                  var chatRoom = chatRooms[index];
                  var timeStamp = chatRoom['timeStamp'] as Timestamp;
                  var creatorId = chatRoom['creatorId'] as String;
                  var memberId = chatRoom['memberId'] as String;
                  var chatRoomID = snapshot.data!.docs[index].id;
                  return FutureBuilder(
                    future: userServices
                        .getUserById(chatRoom['memberId'] as String),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        UserClass user = snapshot.data!;
                        return ChatBoxDisplayWidget(
                          chatMessage: ChatBoxDisplay(
                              profilePicUrl:
                                  'https://static.vecteezy.com/system/resources/thumbnails/005/129/844/small_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg',
                              name: user.name ?? "",
                              email: user.email ?? "",
                              timestamp: timeStamp.toDate() ?? DateTime.now(),
                              onTap: () {
                                print("clickd");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MessagingPage(
                                            SenderId: creatorId,
                                            ReceiverId: memberId,
                                            ChatRoomId: chatRoomID)));
                              }),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    ],
  );
}
