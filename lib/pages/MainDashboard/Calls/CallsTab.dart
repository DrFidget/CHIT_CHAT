import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ourappfyp/services/UserCollectionFireStore/usersCollection.dart';
import 'package:ourappfyp/types/UserClass.dart';

class CallsTab extends StatefulWidget {
  const CallsTab({super.key});

  @override
  State<CallsTab> createState() => _CallsTabState();
}

class _CallsTabState extends State<CallsTab> {
  final String loggedInUserId = FirebaseAuth.instance.currentUser!.uid;
  final UserFirestoreService userFirestoreService = UserFirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call Logs'),
      ),
      body: DisplayAllCalls(loggedInUserId: loggedInUserId, userFirestoreService: userFirestoreService),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: Icon(Icons.add),
      ),
    );
  }
}

class DisplayAllCalls extends StatelessWidget {
  final String loggedInUserId;
  final UserFirestoreService userFirestoreService;

  DisplayAllCalls({required this.loggedInUserId, required this.userFirestoreService});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('calls')
          .where('callerId', isEqualTo: loggedInUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var callLogs = snapshot.data!.docs.map((doc) => CallLog.fromDocument(doc)).toList();
          if (callLogs.isEmpty) {
            return Center(child: Text('No call logs found'));
          }
          return ListView.builder(
            itemCount: callLogs.length,
            itemBuilder: (context, index) {
              var callLog = callLogs[index];
              return FutureBuilder<UserClass?>(
                future: userFirestoreService.getUserById(callLog.receiverId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Loading...'),
                      subtitle: Text('Loading...'),
                      leading: CircularProgressIndicator(),
                    );
                  }
                  if (!userSnapshot.hasData) {
                    return ListTile(
                      title: Text('Unknown User'),
                      subtitle: Text('Call at ${callLog.startTime}'),
                    );
                  }
                  var user = userSnapshot.data!;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.imageLink ??
                          'https://via.placeholder.com/150'),
                    ),
                    title: Text(user.name ?? 'No Name'),
                    subtitle: Text('Call at ${callLog.startTime}'),
                    trailing: Text(callLog.status),
                  );
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class CallLog {
  final String callerId;
  final String receiverId;
  final String status;
  final DateTime startTime;

  CallLog({
    required this.callerId,
    required this.receiverId,
    required this.status,
    required this.startTime,
  });
  factory CallLog.fromDocument(DocumentSnapshot doc) {
    return CallLog(
      callerId: doc['callerId'],
      receiverId: doc['receiverId'],
      status: doc['status'],
      startTime: (doc['startTime'] as Timestamp).toDate(),
    );
  }
}
