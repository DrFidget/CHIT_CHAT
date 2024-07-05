import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:ourappfyp/pages/navigator.dart';

class CustomNotificationListener {
  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction receivedNotification) async {
    // Your code goes here
    print('Received action: ${receivedNotification}');
    if (receivedNotification.channelKey == 'call_channel') {
      print('Inside if Received action: ${receivedNotification}');
      final payload = receivedNotification.payload;
      if (payload != null) {
        navigateToCallPage(
          payload['callerId'] ?? '',
          payload['callerName'] ?? '',
          payload['roomId'] ?? '',
          payload['receiverId'] ?? '',
        );
      }
    // // Navigate into pages, avoiding to open the notification details page over another details page already opened
    // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/notification-page',
    //         (route) => (route.settings.name != '/notification-page') || route.isFirst,
    //     arguments: receivedAction);
    }
  }
}