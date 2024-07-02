import 'package:permission_handler/permission_handler.dart';

// Future<void> requestPermissions() async {
//   await Permission.microphone.request();
//   await Permission.notification.request();
//   // Add any other permissions you need
// }

Future<void> requestPermissions() async {
  try {
    var status = await [Permission.camera, Permission.microphone].request();
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.camera,
    ].request();
    bool allGranted = statuses.values.every((status) => status.isGranted);
    if (!allGranted) {
      // Handle the case when permissions are not granted
      print('Not all permissions granted.');
      // Show a dialog or navigate to an error screen
    }
  } catch (e) {
    return Future.error(e);
  }
}
