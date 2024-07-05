import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:ourappfyp/manager/webrtc_manager.dart';
import 'package:ourappfyp/pages/call/Calling_page.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/UserCollectionFireStore/usersCollection.dart';

import '../../types/UserClass.dart';
import 'package:flutter/services.dart';
import 'package:ourappfyp/pages/MainDashboard/MainAppStructureDashBoard.dart';

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

  var image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCallerImage();
  }
  Future<void> _loadCallerImage() async {
    try {
      UserFirestoreService userFirestoreService = UserFirestoreService();
      UserClass? currentUser = await userFirestoreService.getUserById(widget.callerId);
      setState(() {
        image = currentUser?.imageLink;
      });
    } catch (e) {
      print("Failed to load caller image: $e");
    }
  }
  Future<void> _acceptCall() async {
    setState(() {
      _isLoading = true;
    });
    FirebaseFirestore.instance.collection('calls').doc(widget.roomId).update({
      'status': 'Accepted',
      'startTime': FieldValue.serverTimestamp(),
    });
    print(widget.callerId);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CallingPage(
          callerId: widget.callerId,
          receiverId: widget.receiverId,
          roomId: widget.roomId,
          UNAME: widget.callername,
          onCallEnd: () {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context)=> AppStructure()), (Route<dynamic> route) => false);// Navigate back to the MessagingPage
          },
        ),
      ),
    );
  }

  void _declineCall() {
    FirebaseFirestore.instance.collection('calls').doc(widget.roomId).update({
      'status': 'Declined',
    });
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context)=> AppStructure()), (Route<dynamic> route) => false); // Navigate back to the MessagingPage
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
              backgroundImage:NetworkImage(image ?? 'https://static.vecteezy.com/system/resources/thumbnails/005/129/844/small_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg'), // Default image if URL is null// Replace with actual caller image URL
            ),
            SizedBox(height: 20),
            Text(
              'Incoming call from ${widget.callername}',
              style: GoogleFonts.jockeyOne(
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
