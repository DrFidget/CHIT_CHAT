import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AudioServiceFirestore {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String?> uploadAudioFile(File audioFile, String fileName) async {
    try {
      firebase_storage.Reference ref = storage.ref().child(fileName);

      firebase_storage.UploadTask uploadTask = ref.putFile(audioFile);
      await uploadTask;

      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } on firebase_storage.FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      return null;
    } catch (e) {
      print('General exception: $e');
      return null;
    }
  }
}
