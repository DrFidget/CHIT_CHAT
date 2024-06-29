import 'package:cloud_firestore/cloud_firestore.dart';

class CallFirestoreService {
  final CollectionReference callCollection = FirebaseFirestore.instance.collection('calls');

  Stream<QuerySnapshot> getCallLogsOfLoggedInPerson(String loggedInUserId) {
    return callCollection.where('participants', arrayContains: loggedInUserId).snapshots();
  }

  Future<void> createCallLog(String callerId, String receiverId) async {
    final callLog = {
      'callerId': callerId,
      'receiverId': receiverId,
      'participants': [callerId, receiverId],
      'status': 'Calling',
      'startTime': FieldValue.serverTimestamp(),
    };
    await callCollection.add(callLog);
  }

  Future<void> updateCallStatus(String callId, String status) async {
    await callCollection.doc(callId).update({
      'status': status,
    });
  }

  Future<void> endCall(String callId) async {
    await callCollection.doc(callId).update({
      'status': 'Ended',
      'endTime': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteCallLog(String callId) async {
    await callCollection.doc(callId).delete();
  }

  Future<DocumentSnapshot> getCallLogById(String callId) async {
    return await callCollection.doc(callId).get();
  }
}
