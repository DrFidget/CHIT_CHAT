import 'package:cloud_functions/cloud_functions.dart';

Future<void> sendCallNotification(String callerId, String callerName,
    String receiverId, String roomId) async {
  HttpsCallable callable =
  FirebaseFunctions.instance.httpsCallable('sendCallNotification');
  try {
    final response = await callable.call(<String, dynamic>{
      'callerId': callerId,
      'callerName': callerName,
      'receiverId': receiverId,
      'roomId': roomId,
    });
    if (response.data['success']) {
      print('Call notification sent successfully.');
    }
  } catch (e) {
    print('Failed to send call notification: $e');
  }
}