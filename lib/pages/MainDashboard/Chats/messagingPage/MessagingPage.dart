import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ourappfyp/Components/Message.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:intl/intl.dart';
import 'package:get/get.dart';

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
  final TextEditingController messageInput = TextEditingController();
  final MessagesFirestoreServices ChatService = MessagesFirestoreServices();
  final chatBoxFirestoreService chatRoomService = chatBoxFirestoreService();
  final UserFirestoreService userservices = UserFirestoreService();
  UserClass? user;

  AudioController audioController = Get.put(AudioController());
  AudioPlayer audioPlayer = AudioPlayer();
  String audioURL = "";
  late String recordFilePath;

  @override
  void initState() {
    super.initState();
    fetchUser();
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
      // Play the recorded audio
      await audioPlayer.play(DeviceFileSource(recordFilePath));
    }
  }

  void fetchUser() async {
    UserClass? fetchedUser = await userservices.getUserById(widget.ReceiverId);
    if (fetchedUser != null) {
      setState(() {
        user = fetchedUser;
      });
    } else {
      // Handle the case where the user is not found
      // For example, show an error message or default to a generic user
    }
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

  @override
  Widget build(BuildContext context) {
    final userName = user != null ? user!.name ?? "Unknown User" : "Loading...";
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 3, 7, 10),
      appBar: AppBar(
        title: Text(
          widget.UNAME ?? userName,
          style: GoogleFonts.jockeyOne(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        backgroundColor: const Color.fromRGBO(109, 40, 217, 1.0),
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ChatService.getChatRoomMEssages(widget.ChatRoomId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var messageData = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      var time = messageData['timeStamp'] as Timestamp;
                      return MessageWidget(
                        dateTime: time.toDate(),
                        backgroundColor:
                            widget.SenderId == messageData['senderID']
                                ? const Color.fromRGBO(109, 40, 217, 1.0)
                                : Colors.white,
                        textColor: widget.SenderId == messageData['senderID']
                            ? Colors.white
                            : Colors.black,
                        text: messageData['message'],
                        alignLeft: widget.SenderId != messageData['senderID'],
                        callback: () => {},
                      );
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
                      style: TextStyle(
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
