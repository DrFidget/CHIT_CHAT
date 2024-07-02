import 'package:permission_handler/permission_handler.dart';

// Future<void> requestPermissions() async {
//   await Permission.microphone.request();
//   await Permission.notification.request();
//   // Add any other permissions you need
// }

Future<void> requestPermissions() async {
  await Future.delayed(Duration(seconds: 1));
  try {
    await Permission.camera.request();
    await Permission.microphone.request();

    bool cameraGranted = await Permission.camera.isGranted;
    bool microphoneGranted = await Permission.microphone.isGranted;

    if (!cameraGranted || !microphoneGranted) {
      print('Not all permissions granted.');
      // Handle the case when permissions are not granted
    }
  } catch (e) {
    return Future.error(e);
  }
}
