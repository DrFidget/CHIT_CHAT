import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';

class ImageServiceFirestore {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String?> uploadImage(Uint8List imageData) async {
    try {
      // Create a reference to the current timestamp (to make the filename unique)
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // Create a reference to the image file under "images" folder using the timestamp as the filename
      firebase_storage.Reference ref =
          storage.ref().child('images/image_$timestamp.jpg');

      // Upload the image data
      firebase_storage.UploadTask uploadTask = ref.putData(imageData);
      await uploadTask;

      // Get the download URL for the image
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      return null;
    } catch (e) {
      print('General exception: $e');
      return null;
    }
  }
}
