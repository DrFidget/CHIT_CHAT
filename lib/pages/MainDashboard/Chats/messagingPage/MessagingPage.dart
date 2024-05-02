import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ourappfyp/Components/Message.dart';
import 'package:ourappfyp/services/ChatBoxCollectionFireStore/chatCollection.dart';
import 'package:ourappfyp/services/MessagesCollectionFireStore/messageCollection.dart';
import 'package:ourappfyp/services/UserCollectionFireStore/usersCollection.dart';
import 'package:ourappfyp/types/MessageClass.dart';
import 'package:ourappfyp/types/UserClass.dart';

class MessagingPage extends StatefulWidget {
  final String SenderId;
  final String ReceiverId;
  final String ChatRoomId;
  final String? RoomId;

  // final String ReceiverName;

  const MessagingPage(
      {super.key,
      required this.SenderId,
      required this.ReceiverId,
      required this.ChatRoomId,
      this.RoomId});

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  final TextEditingController messageInput = TextEditingController();
  final MessagesFirestoreServices ChatService = MessagesFirestoreServices();
  final chatBoxFirestoreService chatRoomService = chatBoxFirestoreService();
  final UserFirestoreService userservices = UserFirestoreService();
  UserClass? user; //get user from widget.reciverId

  @override
  void initState() {
    super.initState();
    // Call the method to fetch the user when the widget initializes
    fetchUser();
  }

  void fetchUser() async {
    // Fetch the user using the provided ReceiverId
    UserClass? fetchedUser = await userservices.getUserById(widget.ReceiverId);
    if (fetchedUser != null) {
      setState(() {
        user = fetchedUser;
      });
    } else {
      // Handle the case where the user is not found
      // For example, show an error message or default to a generic user
    }
  }

  void SendMessage() async {
    if (messageInput.text.isNotEmpty) {
      MessageClass newMessage = MessageClass(
        widget.SenderId,
        widget.ReceiverId,
        Timestamp.now(),
        messageInput.text,
        'text',
        widget.ChatRoomId,
      );
      messageInput.clear();
      await ChatService.addMessage(newMessage);
      chatRoomService.updateChatRoomTimestamp(widget.ChatRoomId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = user != null ? user!.name ?? "Unknown User" : "Loading...";
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 3, 7, 10),
      appBar: AppBar(title: Text(userName)),
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ChatService.getChatRoomMEssages(widget.ChatRoomId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var messageData = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      var time = messageData['timeStamp'] as Timestamp;
                      return MessageWidget(
                          dateTime: time.toDate(),
                          backgroundColor:
                              widget.SenderId == messageData['senderID']
                                  ? Colors.purple
                                  : Colors.white,
                          textColor: widget.SenderId == messageData['senderID']
                              ? Colors.white
                              : Colors.black,
                          text: messageData['message'],
                          alignLeft: widget.SenderId == messageData['senderID']
                              ? false
                              : true,
                          callback: () => {});
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          buildMessageInput(),
        ],
      ),
    );
  }

  Widget buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageInput,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Type a message",
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: SendMessage,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ],
      ),
    );
  }
}
