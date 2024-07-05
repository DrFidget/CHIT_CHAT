import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class TokenService {
  Future<String?> getUserIdByEmail(String email) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id; // Assuming the document ID is the user ID
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting user ID by email: $e");
      return null;
    }
  }

  Future<void> saveTokenToDatabase(String email) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        String? userId = await getUserIdByEmail(email);

        if (userId != null) {
          var userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

          await FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot userDoc = await transaction.get(userDocRef);

            if (!userDoc.exists) {
              throw Exception("User document does not exist");
            }

            if (userDoc.data() != null && (userDoc.data() as Map<String, dynamic>).containsKey('fcmTokens')) {
              transaction.update(userDocRef, {
                'fcmToken': FieldValue.arrayUnion([token]),
              });
            } else {
              transaction.update(userDocRef, {
                'fcmToken': [token],
              });
            }
          });
        } else {
          print("User ID not found for email: $email");
        }
      }
    } catch (e) {
      print("Error saving token to database: $e");
    }
  }
}
