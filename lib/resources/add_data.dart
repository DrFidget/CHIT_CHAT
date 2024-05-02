import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class storeData {
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData(
      {required String name,
      required String email,
      required Uint8List file}) async {
    String resp = "Some Error Occured.";
    try {
      if (name.isNotEmpty || email.isNotEmpty) {
        String imageUrl = await uploadImageToStorage('profileImage', file);
        await _firestore.collection('users').add({
          'name': name,
          'email': email,
          'imageLink': imageUrl,
        });
        resp = "Success";
      }
    } catch (error) {
      resp = error.toString();
    }
    return resp;
  }
}
