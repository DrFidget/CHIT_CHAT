import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ourappfyp/services/ChatBoxCollectionFireStore/chatCollection.dart';
import 'package:ourappfyp/services/UserCollectionFireStore/usersCollection.dart';

void showAllGroupUsers(BuildContext context, UserFirestoreService userServices,
    String loggedInUserId) async {
  List<String> selectedUserIds = [];
  TextEditingController groupNameController = TextEditingController();

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (context) => Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: groupNameController,
                    decoration: InputDecoration(
                      labelText: 'Group Name',
                      suffixIcon: Icon(Icons.group),
                    ),
                  ),
                ),
                Expanded(
                  child: AllUsers(
                    userServices: userServices,
                    scrollController: scrollController,
                    loggedInUserId: loggedInUserId,
                    onSelectUser: (userId) {
                      setState(() {
                        if (selectedUserIds.contains(userId)) {
                          selectedUserIds.remove(userId);
                        } else {
                          selectedUserIds.add(userId);
                        }
                      });
                    },
                    selectedUserIds: selectedUserIds,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (groupNameController.text.isNotEmpty &&
                          selectedUserIds.isNotEmpty) {
                        chatBoxFirestoreService().createGroupChat(
                          loggedInUserId,
                          selectedUserIds,
                          groupNameController.text,
                        );
                        Navigator.pop(context);
                      } else {
                        // Show error message if group name or selected users are empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Please enter a group name and select members')),
                        );
                      }
                    },
                    child: Text('Create Group'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}

class AllUsers extends StatefulWidget {
  const AllUsers({
    super.key,
    required this.userServices,
    required this.scrollController,
    required this.loggedInUserId,
    required this.onSelectUser,
    required this.selectedUserIds,
  });

  final UserFirestoreService userServices;
  final ScrollController scrollController;
  final String loggedInUserId;
  final Function(String) onSelectUser;
  final List<String> selectedUserIds;

  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  String _searchText = "";

  final chatBoxFirestoreService chatServices = chatBoxFirestoreService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Search',
              suffixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: widget.userServices.getStreamOFAllUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var users = snapshot.data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .where((user) =>
                        (user['name'] as String).contains(_searchText))
                    .toList();

                return ListView.builder(
                  controller: widget.scrollController,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];
                    var userId = snapshot.data!.docs[index].id;

                    if (userId != widget.loggedInUserId) {
                      return ListTile(
                        title: Text(user['name'] as String),
                        subtitle: Text(user['email'] as String),
                        trailing: widget.selectedUserIds.contains(userId)
                            ? Icon(Icons.check_box)
                            : Icon(Icons.check_box_outline_blank),
                        onTap: () {
                          widget.onSelectUser(userId);
                        },
                      );
                    }

                    return Container();
                  },
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
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
}
