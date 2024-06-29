import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:ourappfyp/Components/AudioPLayerCompoenent.dart';
import 'package:ourappfyp/Components/Message.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ourappfyp/services/AudioServiceFirestore/AudioServiceFirestore.dart';
import 'package:ourappfyp/services/ChatBoxCollectionFireStore/chatCollection.dart';
import 'package:ourappfyp/services/MessagesCollectionFireStore/messageCollection.dart';
import 'package:ourappfyp/services/UserCollectionFireStore/usersCollection.dart';
import 'package:ourappfyp/types/MessageClass.dart';
import 'package:ourappfyp/types/UserClass.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ourappfyp/pages/MainDashboard/Chats/messagingPage/AudioController.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:ourappfyp/pages/call/Calling_page.dart';
import 'package:ourappfyp/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ourappfyp/pages/navigator.dart';

class MessagingPage extends StatefulWidget {
  final String SenderId;
  final String ReceiverId;
  final String ChatRoomId;
  final String? RoomId;
  final String? UNAME;

  const MessagingPage({
    super.key,
    required this.SenderId,
    required this.ReceiverId,
    required this.ChatRoomId,
    this.RoomId,
    this.UNAME,
  });

  @override
  State<MessagingPage> createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  final ScrollController _scrollController =
      ScrollController(); // Create ScrollController
  final TextEditingController messageInput = TextEditingController();
  final MessagesFirestoreServices ChatService = MessagesFirestoreServices();
  final chatBoxFirestoreService chatRoomService = chatBoxFirestoreService();
  final UserFirestoreService userservices = UserFirestoreService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserClass? user;
  String? firebaseToken1;
  User1? userObject;
  User1? senderObject;
  UserClass? sender;

  AudioController audioController = Get.put(AudioController());
  AudioPlayer audioPlayer = AudioPlayer();
  String audioURL = "";
  late String recordFilePath;
  @override
  void dispose() {
    _scrollController.dispose(); // Dispose ScrollController
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchFirebaseToken();
    requestNotificationPermissions();

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   if (message.data['type'] == 'CALL_NOTIFICATION') {
    //     final callerId = message.data['callerId'] ?? '';
    //     final callerName = message.data['callerName'] ?? '';
    //     final roomId = message.data['roomId'] ?? '';
    //     final receiverId = message.data['receiverId'] ?? '';
    //
    //     if (callerId != null &&
    //         callerName != null &&
    //         roomId != null &&
    //         receiverId != null) {
    //       navigateToCallPage(callerId, callerName, roomId, receiverId);
    //     }
    //   }
    // });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   if (message.data['type'] == 'CALL_NOTIFICATION') {
    //     final callerId = message.data['callerId'] ?? '';
    //     final callerName = message.data['callerName'] ?? '';
    //     final roomId = message.data['roomId'] ?? '';
    //     final receiverId = message.data['receiverId'] ?? '';
    //
    //     if (callerId != null &&
    //         callerName != null &&
    //         roomId != null &&
    //         receiverId != null) {
    //       navigateToCallPage(callerId, callerName, roomId, receiverId);
    //     }
    //   }
    // });
    // Handle when the app is launched from a terminated state by a notification
    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage? message) {
    //   if (message != null && message.data['type'] == 'CALL_NOTIFICATION') {
    //     final callerId = message.data['callerId'] ?? '';
    //     final callerName = message.data['callerName'] ?? '';
    //     final roomId = message.data['roomId'] ?? '';
    //     final receiverId = message.data['receiverId'] ?? '';
    //
    //     if (callerId != null &&
    //         callerName != null &&
    //         roomId != null &&
    //         receiverId != null) {
    //       navigateToCallPage(callerId, callerName, roomId, receiverId);
    //     }
    //   }
    // });
  }

  void _initiateCall() {
    final String roomId = widget.ChatRoomId;
    _firestore.collection('calls').doc(roomId).set({
      'callerId': widget.SenderId,
      'receiverId': widget.ReceiverId,
      'roomId': roomId,
    });

    final senderName = sender?.name ?? 'Unknown';
    sendCallNotification(
        widget.SenderId, senderName, widget.ReceiverId, roomId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallingPage(
          callerId: widget.SenderId,
          receiverId: widget.ReceiverId,
          roomId: roomId,
          UNAME: widget.UNAME ?? "",
          onCallEnd: () {
            Navigator.pop(
                context); // This will navigate back to the MessagingPage
          },
        ),
      ),
    );
  }

  void createUserObject() {
    setState(() {
      userObject = User1(
        name: user!.name ?? "",
        gender: null,
        phoneNumber: user!.email ?? "",
        birthDate: null,
        location: null,
        username: null,
        firstName: "",
        lastName: "",
        title: "",
        picture: user!.imageLink ?? "",
        uuid: user!.ID ?? "",
        firebaseToken: firebaseToken1,
      );
    });
  }

  Future<void> requestNotificationPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void fetchFirebaseToken() async {
    // Get the FCM token
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        firebaseToken1 = token;
        print('FCM Token: $firebaseToken1');
        if (user != null) {
          createUserObject();
        }
      } else {
        print('Failed to fetch FCM token. Token is null.');
        // Optionally, you can implement a retry mechanism here
      }
    } catch (e) {
      print('Error fetching FCM token: $e');
      // Handle the error accordingly
    }
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();
      RecordMp3.instance.start(recordFilePath, (type) {
        setState(() {});
      });
      audioController.isRecording.value = true;
    }
    setState(() {});
  }

  Future<String> getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/recorded_audio_${DateTime.now().millisecondsSinceEpoch}.mp3';
  }

  void stopRecord() async {
    bool stop = RecordMp3.instance.stop();
    audioController.end.value = DateTime.now();
    audioController.calcDuration();
    var ap = AudioPlayer();
    await ap.play(AssetSource("Notification.mp3"));
    ap.onPlayerComplete.listen((a) {});
    if (stop) {
      audioController.isRecording.value = false;
      audioController.isSending.value = true;

      try {
        final AudioServiceFirestore audioService = AudioServiceFirestore();
        String? uploadedURL = await audioService.uploadAudioFile(
            File(recordFilePath),
            "audio/${DateTime.now().microsecondsSinceEpoch.toString()}");
        if (uploadedURL != null) {
          audioURL = uploadedURL;
          print("Audio URL: $audioURL"); // Debugging statement
          SendAudioMessage();
        } else {
          print("Failed to upload audio file."); // Handle the error
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void fetchUser() async {
    // Fetch the user using the provided ReceiverId
    UserClass? fetchedUser = await userservices.getUserById(widget.ReceiverId);
    UserClass? senderUser = await userservices.getUserById(widget.SenderId);
    if (fetchedUser != null) {
      setState(() {
        user = fetchedUser;
        sender = senderUser;
      });
      if (firebaseToken1 != null) {
        createUserObject();
      }
    } else {}
  }

  void SendMessage() async {
    if (messageInput.text.isNotEmpty) {
      MessageClass newMessage = MessageClass(
        widget.SenderId,
        widget.ReceiverId,
        Timestamp.now(),
        messageInput.text,
        'text',
        widget.ChatRoomId,
      );
      messageInput.clear();
      await ChatService.addMessage(newMessage);
      chatRoomService.updateChatRoomTimestamp(widget.ChatRoomId);
    }
  }

  Future<void> sendCallNotification(String callerId, String callerName,
      String receiverId, String roomId) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('sendCallNotification');
    try {
      final response = await callable.call(<String, dynamic>{
        'callerId': callerId,
        'callerName': callerName,
        'receiverId': receiverId,
        'roomId': roomId,
      });
      if (response.data['success']) {
        print('Call notification sent successfully.');
      }
    } catch (e) {
      print('Failed to send call notification: $e');
    }
  }

  void SendAudioMessage() async {
    if (audioURL.isNotEmpty) {
      MessageClass newMessage = MessageClass(
        widget.SenderId,
        widget.ReceiverId,
        Timestamp.now(),
        audioURL,
        'audio',
        widget.ChatRoomId,
      );
      audioURL = '';
      await ChatService.addMessage(newMessage);
      chatRoomService.updateChatRoomTimestamp(widget.ChatRoomId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName =
        widget.UNAME ?? "Unknown User"; // Use widget.UNAME directly

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 3, 7, 10),
      appBar: AppBar(
        title: Text(
          userName,
          style: GoogleFonts.jockeyOne(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color.fromRGBO(109, 40, 217, 1.0),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: _initiateCall,
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ChatService.getChatRoomMEssages(widget
                  .ChatRoomId), // Assuming ChatService is your service to get messages
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Scroll to bottom whenever new data arrives
                  WidgetsBinding.instance?.addPostFrameCallback((_) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  });

                  return ListView.builder(
                    controller:
                        _scrollController, // Assign ScrollController to ListView
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var messageData = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      var time = messageData['timeStamp'] as Timestamp;
                      var typeOfMessage = messageData['type'] as String;
                      var messageID = snapshot.data!.docs[index].id as String;
                      return typeOfMessage == 'text'
                          ? MessageWidget(
                              dateTime: time.toDate(),
                              backgroundColor:
                                  widget.SenderId == messageData['senderID']
                                      ? const Color.fromRGBO(109, 40, 217, 1.0)
                                      : Colors.white,
                              textColor:
                                  widget.SenderId == messageData['senderID']
                                      ? Colors.white
                                      : Colors.black,
                              text: messageData['message'],
                              alignLeft:
                                  widget.SenderId != messageData['senderID'],
                              callback: () {
                                try {
                                  ChatService.deketeDocFromID(messageID);
                                } catch (e) {}
                              },
                            )
                          : AudioMessageWidget(
                              dateTime: time.toDate(),
                              backgroundColor:
                                  widget.SenderId == messageData['senderID']
                                      ? const Color.fromRGBO(109, 40, 217, 1.0)
                                      : Colors.white,
                              textColor:
                                  widget.SenderId == messageData['senderID']
                                      ? Colors.white
                                      : Colors.black,
                              audioUrl: messageData['message'],
                              alignLeft:
                                  widget.SenderId != messageData['senderID'],
                              callback: () {
                                try {
                                  ChatService.deketeDocFromID(messageID);
                                } catch (e) {}
                              }); // Replace with your AudioMessageWidget
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          buildMessageInput(),
        ],
      ),
    );
  }

  Widget buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTapDown: (_) async {
                  var audioPlayer = AudioPlayer();
                  await audioPlayer.play(AssetSource("Notification.mp3"));
                  audioPlayer.onPlayerComplete.listen((a) {
                    audioController.start.value = DateTime.now();
                    startRecord();
                  });
                },
                onTapUp: (_) {
                  stopRecord();
                },
                child: Icon(Icons.mic,
                    color: const Color.fromRGBO(109, 40, 217, 1.0)),
              ),
              SizedBox(
                  width:
                      10), // Add space between the mic icon and the text input field
              Expanded(
                child: TextField(
                  controller: messageInput,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Type a message",
                    hintStyle: GoogleFonts.jockeyOne(
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 104, 103, 103),
                        fontSize: 18,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: SendMessage,
                      color: const Color.fromRGBO(109, 40, 217, 1.0),
                    ),
                  ),
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ],
          ),
          Obx(() {
            return audioController.isRecording.value
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Recording Audio...',
                      style: GoogleFonts.jockeyOne(
                          color: const Color.fromRGBO(109, 40, 217, 1.0)),
                    ),
                  )
                : SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
