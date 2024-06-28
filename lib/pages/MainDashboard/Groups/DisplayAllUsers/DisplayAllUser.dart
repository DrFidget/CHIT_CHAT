import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            return Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: groupNameController,
                      decoration: InputDecoration(
                        labelText: 'Enter Group Name...',
                        labelStyle: GoogleFonts.jockeyOne(color: Colors.white),
                        suffixIcon: Icon(Icons.group, color: Colors.white),
                        filled: true,
                        fillColor: const Color.fromRGBO(109, 40, 217, 1.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color.fromRGBO(109, 40, 217, 1.0)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: const Color.fromRGBO(109, 40, 217, 1.0)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      style: TextStyle(
                          color: Colors.white), // Set the text color to white
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromRGBO(109, 40, 217, 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
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
                      child: Text('Create Group',
                          style: GoogleFonts.jockeyOne(color: Colors.white)),
                    ),
                  ),
                ],
              ),
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
              labelText: 'Search...',
              labelStyle: GoogleFonts.jockeyOne(color: Colors.white),
              suffixIcon: Icon(Icons.search, color: Colors.white),
              filled: true,
              fillColor: const Color.fromRGBO(109, 40, 217, 1.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: const Color.fromRGBO(109, 40, 217, 1.0)),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: const Color.fromRGBO(109, 40, 217, 1.0)),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            style:
                TextStyle(color: Colors.white), // Set the text color to white
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
                        title: Text(user['name'] as String,
                            style: GoogleFonts.jockeyOne(color: Colors.white)),
                        subtitle: Text(user['email'] as String,
                            style: GoogleFonts.jockeyOne(color: Colors.white)),
                        trailing: widget.selectedUserIds.contains(userId)
                            ? Icon(Icons.check_box, color: Colors.white)
                            : Icon(Icons.check_box_outline_blank,
                                color: Colors.white),
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
                return Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.white));
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
