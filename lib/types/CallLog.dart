import 'package:cloud_firestore/cloud_firestore.dart';

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
