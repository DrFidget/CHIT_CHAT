import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ourappfyp/models/user.dart';
class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> sendNotification(String roomId, User1 recipientUser) async {
    try {
      // Get the recipient user's FCM token
      String? recipientToken = recipientUser.firebaseToken;
      if (recipientToken == null) {
        throw Exception("Recipient's FCM token is null.");
      }

      // Construct the notification message
      var message = {
        'notification': {
          'title': 'Incoming Call',
          'body': 'You have an incoming call.',
        },
        'data': {
          'roomId': roomId,
          // Add any additional data you want to send with the notification
        },
        'token': recipientToken,
      };

      // Send the notification using the Firebase Messaging API
      await _firebaseMessaging.sendMessage();
    } catch (e) {
      print('Failed to send notification: $e');
      // Handle any errors or exceptions
    }
  }
}
