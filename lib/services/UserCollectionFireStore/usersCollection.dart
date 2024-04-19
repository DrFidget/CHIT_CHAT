import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirestoreService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String name, String email, String password) {
    return users.add({
      'name': name,
      'email': email,
      'password': password,
      'timeStamp': Timestamp.now()
    });
  }

  //edit user by id
  //delete user by id
  //get users []
  Stream<QuerySnapshot> getAllUsersFromDB() {
    return users.snapshots();
  }
  //get user by id {}
}
