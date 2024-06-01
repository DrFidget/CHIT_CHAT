import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:ourappfyp/manager/webrtc_manager.dart';
import 'package:ourappfyp/pages/call/Calling_page.dart';

class CallAcceptDeclinePage extends StatefulWidget {
  final String callerId;
  final String receiverId;
  final String roomId;

  const CallAcceptDeclinePage({
    Key? key,
    required this.callerId,
    required this.receiverId,
    required this.roomId,
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
      appBar: AppBar(
        title: Text('Incoming Call from ${widget.callerId}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Incoming call from ${widget.callerId}'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _acceptCall,
                  child: Text('Accept'),
                ),
                ElevatedButton(
                  onPressed: _declineCall,
                  child: Text('Decline'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
