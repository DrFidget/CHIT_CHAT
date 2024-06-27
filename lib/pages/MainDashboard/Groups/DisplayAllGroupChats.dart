import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ourappfyp/pages/MainDashboard/Chats/messagingPage/MessagingPageGroup.dart';
import 'package:ourappfyp/services/ChatBoxCollectionFireStore/chatCollection.dart';
import 'package:ourappfyp/Components/GroupChatBoxDsiplay.dart';
import 'package:ourappfyp/types/UserClass.dart';

Widget DisplayAllGroupChats(
    String loggedInUserId, chatBoxFirestoreService chatServices) {
  return Column(
    children: [
      Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream:
              chatServices.getGroupChatRoomsOfLoggedInPerson(loggedInUserId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var chatRooms = snapshot.data!.docs;
              return ListView.builder(
                itemCount: chatRooms.length,
                itemBuilder: (context, index) {
                  var chatRoom = chatRooms[index];
                  var timeStamp = chatRoom['timeStamp'] as Timestamp;
                  var groupName = chatRoom['name'] as String;
                  var chatRoomID = snapshot.data!.docs[index].id;

                  return GroupChatBoxDisplayWidget(
                    groupChat: GroupChatBoxDisplay(
                      groupPicUrl:
                          'https://static.vecteezy.com/system/resources/thumbnails/005/129/844/small_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg',
                      groupName: groupName,
                      timestamp: timeStamp.toDate() ?? DateTime.now(),
                      onTap: () {
                        print("Clicked on $groupName");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessagingPageGroup(
                              SenderId: loggedInUserId,
                              ReceiverId: chatRoomID,
                              ChatRoomId: chatRoomID,
                              UNAME: groupName,
                            ),
                          ),
                        );
                      },
                    ),
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
