import 'package:flutter/material.dart';
import 'package:ourappfyp/pages/call/Calling_page.dart';
import 'package:ourappfyp/pages/call/call_accept_decline_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void navigateToCallPage(String callerId, String callerName, String roomId, String receiverId) {
  navigatorKey.currentState?.push(
    MaterialPageRoute(
      builder: (context) => CallAcceptDeclinePage(
        callerId: callerId,
        receiverId: receiverId,
        roomId: roomId,
      ),
    ),
  );
}