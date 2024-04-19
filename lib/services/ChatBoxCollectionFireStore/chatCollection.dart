import 'package:cloud_firestore/cloud_firestore.dart';

class chatBoxFirestoreService {
  final CollectionReference chatBox =
      FirebaseFirestore.instance.collection('chatBox');

  Future<void> createChatBox(
      String creatorId, String memberIds, String? TypeOfChatroom) {
    return chatBox.add({
      'creatorId': creatorId,
      'memberIds': memberIds,
      'TypeOfChatroom': TypeOfChatroom ?? "dm",
      'createdAt': Timestamp.now(),
    }).then((value) {
      print(value.id);
    }).catchError((e) {
      print(e);
    });
  }
}
