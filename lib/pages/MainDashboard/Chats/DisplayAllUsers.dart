import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourappfyp/services/ChatBoxCollectionFireStore/chatCollection.dart';
import 'package:ourappfyp/services/UserCollectionFireStore/usersCollection.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({
    super.key,
    required this.userServices,
    required this.scrollController,
    required this.loggedInUserId,
  });

  final UserFirestoreService userServices;
  final ScrollController scrollController;
  final String loggedInUserId;

  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  String _searchText = "";

  final chatBoxFirestoreService chatServices = chatBoxFirestoreService();

  @override
  Widget build(BuildContext context) {
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
              onChanged: (value) {
                setState(() {
                  _searchText =
                      value.toLowerCase(); // Convert search text to lowercase
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
              style: GoogleFonts.jockeyOne(color: Colors.white),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: widget.userServices.getStreamOFAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var users = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .where((user) => (user['name'] as String)
                          .toLowerCase()
                          .contains(
                              _searchText)) // Convert user names to lowercase for comparison
                      .toList();

                  return ListView.builder(
                    controller: widget.scrollController,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var user = users[index];

                      if (snapshot.data!.docs[index].id !=
                          widget.loggedInUserId) {
                        return ListTile(
                          title: Text(
                            user['name'] as String,
                            style: GoogleFonts.jockeyOne(color: Colors.white),
                          ),
                          subtitle: Text(
                            user['email'] as String,
                            style: GoogleFonts.jockeyOne(color: Colors.white70),
                          ),
                          onTap: () {
                            try {
                              onTapUser(widget.loggedInUserId,
                                  snapshot.data!.docs[index].id, chatServices);
                            } catch (e) {
                              print(e);
                            }
                          },
                        );
                      }

                      return Container();
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
      ),
    );
  }
}

void showAllUsers(BuildContext context, UserFirestoreService userServices,
    String loggedInUserId) async {
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
        builder: (context, scrollController) => AllUsers(
          userServices: userServices,
          scrollController: scrollController,
          loggedInUserId: loggedInUserId,
        ),
      ),
    ),
  );
}

void onTapUser(
    String CreatorID, String MemberID, chatBoxFirestoreService chatServices) {
  chatServices.createChatRoom(CreatorID, MemberID);
}
