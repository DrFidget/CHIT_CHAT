import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ourappfyp/types/UserClass.dart';
import 'package:intl/intl.dart';

String getFormattedTimestamp() {
  Timestamp timestamp = Timestamp.now();
  DateTime date = timestamp.toDate();

  var format = DateFormat('dd-MM-yyyy:HH:mm:ss');
  String formattedDate = format.format(date);

  return formattedDate;
}

class UserFirestoreService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String name, String email, String password) {
    return users.add({
      'name': name,
      'email': email,
      'password': password,
      'timeStamp': getFormattedTimestamp()
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
}
