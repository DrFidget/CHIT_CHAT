import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ourappfyp/Components/ListItemComponent.dart';
import 'package:ourappfyp/pages/MainDashboard/ChatiingPage.dart';
import 'package:ourappfyp/services/ChatBoxCollectionFireStore/chatCollection.dart';
import 'package:ourappfyp/services/UserCollectionFireStore/usersCollection.dart';
import 'package:ourappfyp/types/ChatRoomClass.dart';
import 'package:ourappfyp/types/UserClass.dart';

class ChatRoomListScreen extends StatefulWidget {
  final String loggedInUserId;

  const ChatRoomListScreen({Key? key, required this.loggedInUserId})
      : super(key: key);

  @override
  _ChatRoomListScreenState createState() => _ChatRoomListScreenState();
}

class _ChatRoomListScreenState extends State<ChatRoomListScreen> {
  late Future<List<ChatRoom>> _chatRoomsFuture;
  final chatBoxFirestoreService ChatRoomService = chatBoxFirestoreService();

  @override
  void initState() {
    super.initState();
    _chatRoomsFuture = _fetchChatRooms();
  }

  Future<List<ChatRoom>> _fetchChatRooms() async {
    return await ChatRoomService.getAllChatRoomsByCreatorId(
        widget.loggedInUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Rooms'),
      ),
      body: DIsplayAllChats(chatRoomsFuture: _chatRoomsFuture),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewChatRoomBottomSheet(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showNewChatRoomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return NewChatRoomBottomSheet(
          onCreateChatRoom: (selectedUserId) {
            _createChatRoom(selectedUserId);
            Navigator.pop(context); // Close the bottom sheet
          },
        );
      },
    );
  }

  void _createChatRoom(String selectedUserId) async {
    // Fetch user details using selectedUserId
    UserClass? selectedUser =
        await UserFirestoreService().getUserById(selectedUserId);
    if (selectedUser != null) {
      // Create new chat room using selected user's details
      // You need to implement this functionality in your chatBoxFirestoreService
      await ChatRoomService.addChatRoom(widget.loggedInUserId, selectedUserId);
      // Refresh chat room list
      setState(() {
        _chatRoomsFuture = _fetchChatRooms();
      });
    }
  }
}

class NewChatRoomBottomSheet extends StatefulWidget {
  final Function(String) onCreateChatRoom;

  const NewChatRoomBottomSheet({Key? key, required this.onCreateChatRoom})
      : super(key: key);

  @override
  _NewChatRoomBottomSheetState createState() => _NewChatRoomBottomSheetState();
}

class _NewChatRoomBottomSheetState extends State<NewChatRoomBottomSheet> {
  TextEditingController _searchController = TextEditingController();
  late Stream<QuerySnapshot> _usersStream;

  @override
  void initState() {
    super.initState();
    _usersStream = FirebaseFirestore.instance.collection('users').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select a user to start a new chat room:',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              // Filter users based on search query
              setState(() {
                _usersStream = FirebaseFirestore.instance
                    .collection('users')
                    .where('name', isGreaterThanOrEqualTo: value)
                    .where('name',
                        isLessThan: value + 'z') // Assuming names are lowercase
                    .snapshots();
              });
            },
          ),
          SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                List<DocumentSnapshot> users = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];
                    return ListItemComponent(
                      backgroundColor: Colors.purple,
                      widthPercent: .7,
                      text: user['name'],
                      callback: () {
                        widget.onCreateChatRoom(
                            user.id); // Pass user ID to create chat room
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DIsplayAllChats extends StatelessWidget {
  final Future<List<ChatRoom>> chatRoomsFuture;
  // final String loggedInUserId;
  const DIsplayAllChats({Key? key, required this.chatRoomsFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChatRoom>>(
      future: chatRoomsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        List<ChatRoom> chatRooms = snapshot.data ?? [];

        if (chatRooms.isEmpty) {
          return Center(child: Text('No chat rooms available.'));
        }

        return ListView.builder(
          itemCount: chatRooms.length,
          itemBuilder: (context, index) {
            ChatRoom chatRoom = chatRooms[index];
            return ListTile(
              title: Text('Chat with ${chatRoom.memberId}'), // Adjust as needed
              subtitle: Text(chatRoom.timeStamp ?? ''), // Adjust as needed
              onTap: () {
                // Navigate to chat room or perform any action here
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => ChattingPage(
                //             SenderId: loggedInUserId,
                //             ReceiverId: chatRoom.memberId,
                //           )),
                // );
              },
            );
          },
        );
      },
    );
  }
}
