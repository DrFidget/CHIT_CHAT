import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ourappfyp/Components/Message.dart';
import 'package:ourappfyp/services/MessagesCollectionFireStore/messageCollection.dart';
import 'package:ourappfyp/types/MessageClass.dart';

class ChattingPage extends StatefulWidget {
  final String SenderId;
  final String ReceiverId;
  final String RoomId;
  // final String ReceiverName;
  final String ChatRoomId;

  const ChattingPage(
      {super.key,
      required this.SenderId,
      required this.ReceiverId,
      required this.ChatRoomId,
      required this.RoomId});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final TextEditingController messageInput = TextEditingController();
  final MessagesFirestoreServices ChatService = MessagesFirestoreServices();
  // late Stream<QuerySnapshot> messagesStream;

  void SendMessage() async {
    if (messageInput.text.isNotEmpty) {
      MessageClass newMessage = MessageClass(
        widget.SenderId,
        widget.ReceiverId,
        Timestamp.now(),
        // DateTime.now().toString(),
        messageInput.text,
        'text',
        widget.ChatRoomId,
      );
      await ChatService.addMessage(newMessage);
      messageInput.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.ReceiverId)),
      body: Column(
        // Expanded()
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ChatService.getChatRoomMEssages(widget.ChatRoomId),
              // ChatService.getMessages(widget.SenderId, widget.ReceiverId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Process the data here
                  // For example, display the messages in a ListView
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      // Extract message data from snapshot
                      var messageData = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      // Return a widget to display the message
                      return MessageWidget(
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

  // Widget buildMEssageItem(DocumentSnapshot document) {
  //   Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  // }

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
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: SendMessage,
          ),
        ],
      ),
    );
  }
}
