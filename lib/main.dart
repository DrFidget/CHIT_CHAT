import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ourappfyp/pages/settings/GroupSettings/GroupSettings.dart';
import 'package:ourappfyp/pages/settings/generalSettings.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ourappfyp/pages/MainDashboard/MainAppStructureDashBoard.dart';
import 'package:ourappfyp/pages/home/HomePage.dart';
import 'package:ourappfyp/pages/login/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ourappfyp/pages/register/RegistrationPage.dart';
import 'package:ourappfyp/pages/settings/profileSetting.dart';
import 'package:ourappfyp/types/UserClass.dart';
import 'firebase_options.dart';
import 'package:ourappfyp/pages/navigator.dart';
import 'package:ourappfyp/models/user.dart';
import 'package:ourappfyp/models/location.dart';
import 'package:ourappfyp/pages/call/calling_page.dart';
import 'package:ourappfyp/pages/navigator.dart';
import 'package:ourappfyp/services/permission/permission.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  if (message.data['type'] == 'CALL_NOTIFICATION') {
    final callerId = message.data['callerId'] ?? '';
    final callerName = message.data['callerName'] ?? '';
    final roomId = message.data['roomId'] ?? '';
    final receiverId = message.data['receiverId'] ?? '';

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'call_channel',
        title: 'Incoming Call',
        body: '$callerName is calling you',
        payload: {
          'callerId': callerId,
          'callerName': callerName,
          'roomId': roomId,
          'receiverId': receiverId,
        },
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await requestPermissions();
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.data['type'] == 'CALL_NOTIFICATION') {
      final callerId = message.data['callerId'] ?? '';
      final callerName = message.data['callerName'] ?? '';
      final roomId = message.data['roomId'] ?? '';
      final receiverId = message.data['receiverId'] ?? '';

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'call_channel',
          title: 'Incoming Call',
          body: '$callerName is calling you',
          payload: {
            'callerId': callerId,
            'callerName': callerName,
            'roomId': roomId,
            'receiverId': receiverId,
          },
        ),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Message clicked!');
    if (message.data['type'] == 'CALL_NOTIFICATION') {
      final callerId = message.data['callerId'] ?? '';
      final callerName = message.data['callerName'] ?? '';
      final roomId = message.data['roomId'] ?? '';
      final receiverId = message.data['receiverId'] ?? '';
      navigateToCallPage(callerId, callerName, roomId, receiverId);
    }
  });
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(UserClassAdapter());
    await Hive.openBox<UserClass>('userBox');
  } catch (e) {
    print("error loading hive error : $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.a
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      //  home: RegistrationPage()
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        //'/callScreen': (context) => const CallScreen(),
        '/MainApp': (context) => const AppStructure(),
        '/profileSettings': (context) => ProfileScreen(),
        // '/Dashboard_Page': (context) => Dashboard_Page(),
        // '/SettingsScreen': (context) => SettingsScreen(),
      },
    );
  }
}
