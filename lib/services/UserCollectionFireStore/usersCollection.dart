import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ourappfyp/types/UserClass.dart';

class UserFirestoreService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String name, String email, String password, String? fcmToken) {
    return users.add({
      'name': name,
      'email': email,
      'password': password,
      'fcmToken': fcmToken, // Add FCM token to the user document
      'timeStamp': Timestamp.now().toString(),
      'imageLink':
      'https://firebasestorage.googleapis.com/v0/b/chattingapp-chitchat.appspot.com/o/profileImage?alt=media&token=3bc23625-b6af-4e67-a541-e28fce9b2985',
    });
  }

  Future<UserClass?> getUserByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot =
          await users.where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        UserClass user =
            UserClass.fromJson(docSnapshot.data() as Map<String, dynamic>);
        user.ID = docSnapshot.id;
        return user;
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  Future<List<UserClass>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await users.get();
      List<UserClass> userList = [];
      for (var doc in querySnapshot.docs) {
        UserClass user = UserClass.fromJson(doc.data() as Map<String, dynamic>);
        user.ID = doc.id;
        userList.add(user);
      }
      return userList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<UserClass?> getUserById(String id) async {
    try {
      DocumentSnapshot docSnapshot = await users.doc(id).get();
      if (docSnapshot.exists) {
        UserClass user =
            UserClass.fromJson(docSnapshot.data() as Map<String, dynamic>);
        user.ID = docSnapshot.id;
        return user;
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  Future<void> updateUserById(
      String id, String name, String email, String password) {
    UserClass user = UserClass(name: name, email: email, password: password);
    return users.doc(id).update({
      'name': user.name,
      'email': user.email,
      'password': user.password,
      'timeStamp': user.timeStamp
    });
  }

  Stream<QuerySnapshot> getStreamOFAllUsers() {
    try {
      return users.snapshots();
    } catch (e) {
      print("Error fetching user stream: $e");
      throw e; // Rethrow the error so it can be caught where the stream is used.
    }
  }
}
