import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ourappfyp/services/UserCollectionFireStore/usersCollection.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({
    super.key,
    required this.userServices,
    required this.scrollController,
  });

  final UserFirestoreService userServices;
  final ScrollController scrollController;

  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  String _searchText = "";

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
                    return ListTile(
                      title: Text(user['name'] as String),
                      subtitle: Text(user['email'] as String),
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
}

void showAllUsers(
    BuildContext context, UserFirestoreService userServices) async {
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
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => AllUsers(
          userServices: userServices,
          scrollController: scrollController,
        ),
      ),
    ),
  );
}
