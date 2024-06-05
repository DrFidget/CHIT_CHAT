import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:ourappfyp/manager/webrtc_manager.dart';
import 'package:ourappfyp/pages/call/Calling_page.dart';

class CallAcceptDeclinePage extends StatefulWidget {
  final String callerId;
  final String receiverId;
  final String roomId;
  final String callername;
  const CallAcceptDeclinePage({
    Key? key,
    required this.callerId,
    required this.receiverId,
    required this.roomId,
    required this.callername,
  }) : super(key: key);

  @override
  _CallAcceptDeclinePageState createState() => _CallAcceptDeclinePageState();
}

class _CallAcceptDeclinePageState extends State<CallAcceptDeclinePage> {

  void _acceptCall() {
    FirebaseFirestore.instance.collection('calls').doc(widget.roomId).update({
      'status': 'Accepted',
      'startTime': FieldValue.serverTimestamp(),
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CallingPage(
          callerId: widget.callerId,
          receiverId: widget.receiverId,
          roomId: widget.roomId,
          UNAME: widget.callername,
          onCallEnd: () {
            Navigator.pop(context); // Navigate back to the MessagingPage
          },
        ),
      ),
    );
  }

  void _declineCall() {
    FirebaseFirestore.instance.collection('calls').doc(widget.roomId).update({
      'status': 'Declined',
    });
    Navigator.pop(context); // Navigate back to the MessagingPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with actual caller image URL
            ),
            SizedBox(height: 20),
            Text(
              'Incoming call from ${widget.callername}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.call, color: Colors.green, size: 50),
                  onPressed: _acceptCall,
                ),
                IconButton(
                  icon: Icon(Icons.call_end, color: Colors.red, size: 50),
                  onPressed: _declineCall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
