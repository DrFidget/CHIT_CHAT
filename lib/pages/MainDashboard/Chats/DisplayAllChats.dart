import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ourappfyp/services/ChatBoxCollectionFireStore/chatCollection.dart';

Widget DisplayAllChatsWithUsers(
    String loggedInUserId, chatBoxFirestoreService chatServies) {
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
                  var memberId = chatRoom['members'] as List<dynamic>;
                  var memberIdsJoined = memberId.join(', ');
                  return ListTile(
                    title: Text('Chat Room Members: $memberIdsJoined'),
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
