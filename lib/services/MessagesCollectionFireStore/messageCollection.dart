import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ourappfyp/types/MessageClass.dart';

class MessagesFirestoreServices {
  final CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  Future<void> addMessage(MessageClass message) {
    message.printMessageDetails(message);

    final Timestamp ts = Timestamp.now();
    return messages.add({
      'type': message.type,
      'message': message.message,
      'timeStamp': ts,
      'reciverID': message.reciverID,
      'senderID': message.senderID,
      'roomId': message.roomId
    });
  }

  Stream<QuerySnapshot> getMessages(String senderID, String reciverID) {
    return messages
        .where('senderID', isEqualTo: senderID)
        .where('reciverID', isEqualTo: reciverID)
        .orderBy('timeStamp', descending: false)
        //  .limit(10)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatRoomMEssages(String ChatRoomID) {
    return messages
        .where('roomId', isEqualTo: ChatRoomID)
        .orderBy('timeStamp', descending: false)
        //  .limit(10)
        .snapshots();
  }
}
