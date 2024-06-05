import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:line_icons/line_icon.dart';
import 'package:ourappfyp/manager/webrtc_manager.dart';
import 'package:flutter/services.dart';
import 'package:audio_session/audio_session.dart';
import '../../services/UserCollectionFireStore/usersCollection.dart';
import '../../services/permission/permission.dart';
import '../../types/UserClass.dart';


class CallingPage extends StatefulWidget {
  final String callerId;
  final String receiverId;
  final String roomId;
  final VoidCallback onCallEnd;
  final String UNAME;


  const CallingPage({
    Key? key,
    required this.callerId,
    required this.receiverId,
    required this.roomId,
    required this.onCallEnd,
    required this.UNAME,
  }) : super(key: key);

  @override
  _CallingPageState createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
  WebRTCManager _webRTCManager = WebRTCManager();
  bool _micMuted = false;
  bool _speakerOn = false;
  Timer? _callTimer;
  int _callDuration = 0;
  String _callStatus = 'Calling';
  DateTime? _startTime;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  TextEditingController textEditingController = TextEditingController(text: '');
  UserFirestoreService userFirestoreService = UserFirestoreService();
  String? room;
  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {

    _localRenderer.initialize();
    _remoteRenderer.initialize();
    _webRTCManager.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
    requestPermissions().then((_) {
      // Handle cases where permissions are not granted
      if (!mounted) return;
      setState(() {});
    });
    _startCall();
    _listenToCallStatus();
  }

  Future<void> _requestAudioFocus() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    await session.setActive(true);
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        // Handle audio focus lost
        print('Audio focus lost');
      } else {
        // Handle audio focus gained
        print('Audio focus gained');
      }
    });
  }
  Future<void> _startCall() async {
    // Initialize Firestore service

    // Request audio focus
    await _requestAudioFocus();

    // Open user media to initialize local video and audio streams
    await _webRTCManager.openUserMedia(_localRenderer, _remoteRenderer);

    // Fetch current user's document by email
    final String currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    UserClass? currentUser = await userFirestoreService.getUserByEmail(currentUserEmail);
    if (currentUser == null) {
      print("User not found");
      return;
    }
    final String? currentUserId = currentUser.ID;

    // Handle room creation or joining
    if (currentUserId == widget.callerId) {
      room = await _webRTCManager.createRoom(_remoteRenderer);
      print("roomID: $room");
      textEditingController.text = room!;
      // Store room ID in Firestore
      await FirebaseFirestore.instance.collection('calls').doc(widget.roomId).set({
        'roomId': room,
        'callerId': currentUserId,
        'receiverId': widget.receiverId,
        'status': 'Calling',
      });
      _updateCallStatus('Calling');
    } else {
      // Retrieve room ID from Firestore
      DocumentSnapshot callDoc = await FirebaseFirestore.instance.collection('calls').doc(widget.roomId).get();
      if (callDoc.exists) {
        String? roomId = callDoc['roomId'];
        print("Room ID: $roomId");
        if (roomId != null) {
          await _webRTCManager.joinRoom(roomId,_remoteRenderer,);
        } else {
          print("Room ID not found in Firestore");
        }
      } else {
        print("Call document not found in Firestore");
      }
    }
    _webRTCManager.toggleSpeaker(false);
  }




  void _startCallTimer() {
    if (_startTime != null) {
      _callTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _callDuration = DateTime.now().difference(_startTime!).inSeconds;
        });
      });
    }
  }

  void _stopCallTimer() {
    _callTimer?.cancel();
  }

  void _updateCallStatus(String status) {
    if (!mounted) return; // Ensure the widget is still mounted
    setState(() {
      _callStatus = status;
    });
    FirebaseFirestore.instance.collection('calls').doc(widget.roomId).update({
      'status': status,
    });
  }
  void _listenToCallStatus() {
    FirebaseFirestore.instance.collection('calls').doc(widget.roomId).snapshots().listen((snapshot) async {
      if (snapshot.exists && snapshot.data() != null) {
        setState(() {
          _callStatus = snapshot.data()!['status'] ?? 'Ringing';
          if (_callStatus == 'Accepted' && snapshot.data()!['startTime'] != null) {
            _startTime = (snapshot.data()!['startTime'] as Timestamp).toDate();
            _startCallTimer();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _stopCallTimer();
    _webRTCManager?.endCall();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  void _toggleMic() {
    setState(() {
      _micMuted = !_micMuted;
    });
    _webRTCManager?.toggleMicrophone(_micMuted);
  }

  void _toggleSpeaker() {
    setState(() {
      _speakerOn = !_speakerOn;
    });
    _webRTCManager?.toggleSpeaker(_speakerOn);
  }
  Future<void> _releaseAudioFocus() async {
    final session = await AudioSession.instance;
    await session.setActive(false);
  }
  void _endCall() {
    _stopCallTimer();
    _updateCallStatus('Ended');
    _webRTCManager?.endCall();
    widget.onCallEnd();
    _releaseAudioFocus();
  }

  String _formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(height: 50),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with actual caller image URL
              ),
              SizedBox(height: 20),
              Text(
                widget.UNAME,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Status: $_callStatus',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              Text(
                'Call Duration: ${_formatDuration(_callDuration)}',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Container(
            color: Color.fromRGBO(109, 40, 217, 1),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    _speakerOn ? Icons.volume_up : Icons.volume_off,
                    color: Colors.white,
                  ),
                  onPressed: _toggleSpeaker,
                ),
                IconButton(
                  icon: Icon(
                    _micMuted ? Icons.mic_off : Icons.mic,
                    color: Colors.white,
                  ),
                  onPressed: _toggleMic,
                ),
                IconButton(
                  icon: Icon(Icons.call_end, color: Colors.red),
                  onPressed: _endCall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}