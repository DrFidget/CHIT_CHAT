import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

typedef void StreamStateCallback(MediaStream stream);

class WebRTCManager {

  final Map<String, dynamic> configuration = {
    'iceServers': [
      {'urls': [
  'stun:stun1.l.google.com:19302',
  'stun:stun2.l.google.com:19302'
  ]},

    ],
  };

  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  String? roomId;
  String? currentRoomText;
  StreamStateCallback? onAddRemoteStream;

  WebRTCManager({this.onAddRemoteStream});

  Future<void> _requestPermissions() async {
    var status = await Permission.microphone.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      print("PERMISSION NAIIII MILIIII");
      return;
    }
  }
  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('Connection state change: $state');
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      print('Signaling state change: $state');
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE connection state change: $state');
    };
  }
  Future<void> openUserMedia(
      RTCVideoRenderer localVideo,
      RTCVideoRenderer remoteVideo,
      ) async {
    var stream = await navigator.mediaDevices.getUserMedia({'video': false, 'audio': true});

    localVideo.srcObject = stream;
    localStream = stream;

    remoteVideo.srcObject = await createLocalMediaStream('key');
  }
  Future<void> initialize() async {
    await _requestPermissions();
    peerConnection = await createPeerConnection(configuration);
    registerPeerConnectionListeners();
    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });
    registerPeerConnectionListeners();

  }



  Future<String> createRoom(RTCVideoRenderer remoteRenderer) async {
    //await initialize();
      //this.roomId = roomId;
    await _requestPermissions();
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentReference roomRef = db.collection('rooms').doc();

    print('Create PeerConnection with configuration: $configuration');

    peerConnection = await createPeerConnection(configuration);

    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });

    // Code for collecting ICE candidates below
    var callerCandidatesCollection = roomRef.collection('callerCandidates');

    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      print('Got candidate: ${candidate.toMap()}');
      callerCandidatesCollection.add(candidate.toMap());
    };
    // Finish Code for collecting ICE candidate

    // Add code for creating a room
    RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    print('Created offer: $offer');

    Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};

    await roomRef.set(roomWithOffer);
    var roomId = roomRef.id;
    print('New room created with SDK offer. Room ID: $roomId');
    currentRoomText = 'Current room is $roomId - You are the caller!';
    // Created a Room

    peerConnection?.onTrack = (RTCTrackEvent event) {
      print('Got remote track: ${event.streams[0]}');

      event.streams[0].getTracks().forEach((track) {
        print('Add a track to the remoteStream $track');
        remoteStream?.addTrack(track);
      });
    };
      roomRef.snapshots().listen((snapshot) async {
        print('Got updated room: ${snapshot.data()}');

        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (peerConnection?.getRemoteDescription() != null &&
            data['answer'] != null) {
          var answer = RTCSessionDescription(
            data['answer']['sdp'],
            data['answer']['type'],
          );

          print("Someone tried to connect");
          await peerConnection?.setRemoteDescription(answer);
        }
      });
      // Listening for remote session description above

      // Listen for remote Ice candidates below
      roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((change) {
          if (change.type == DocumentChangeType.added) {
            Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
            print('Got new remote ICE candidate: ${jsonEncode(data)}');
            peerConnection!.addCandidate(
              RTCIceCandidate(
                data['candidate'],
                data['sdpMid'],
                data['sdpMLineIndex'],
              ),
            );
          }
        });
      });
      // Listen for remote ICE candidates above

      return roomId;
  }

  void toggleMicrophone(bool mute) {
    Fluttertoast.showToast(
        msg: "mic is being called ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
    localStream?.getAudioTracks().forEach((track) {
      track.enabled = !mute;
      print('Microphone ${mute ? 'muted' : 'unmuted'}: ${track
          .id}, enabled: ${track.enabled}');
    });
  }

  void toggleSpeaker(bool speakerOn) {
    Fluttertoast.showToast(
        msg: "speaker is being called ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );
    localStream?.getAudioTracks().forEach((track) {
      track.enableSpeakerphone(speakerOn);
      print('Speakerphone ${speakerOn ? 'enabled' : 'disabled'}: ${track
          .id}, enabled: ${track.enabled}');
    });
  }

  void endCall() {
    peerConnection?.close();
    localStream?.dispose();
    remoteStream?.dispose();
    remoteRenderer.dispose();
  }

  Future<void> joinRoom(String roomId, RTCVideoRenderer remoteVideo) async {
   // await initialize();
    FirebaseFirestore db = FirebaseFirestore.instance;
    print("join");
    print(roomId);
    DocumentReference roomRef = db.collection('rooms').doc('$roomId');
    var roomSnapshot = await roomRef.get();
    print('Got room ${roomSnapshot.exists}');

    if (roomSnapshot.exists) {
      print('Create PeerConnection with configuration: $configuration');
      peerConnection = await createPeerConnection(configuration);

      registerPeerConnectionListeners();

      localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream!);
      });

      // Code for collecting ICE candidates below
      var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
      peerConnection!.onIceCandidate = (RTCIceCandidate? candidate) {
        if (candidate == null) {
          print('onIceCandidate: complete!');
          return;
        }
        print('onIceCandidate: ${candidate.toMap()}');
        calleeCandidatesCollection.add(candidate.toMap());
      };
      // Code for collecting ICE candidate above

      peerConnection?.onTrack = (RTCTrackEvent event) {
        print('Got remote track: ${event.streams[0]}');
        event.streams[0].getTracks().forEach((track) {
          print('Add a track to the remoteStream: $track');
          remoteStream?.addTrack(track);
        });
      };

      // Code for creating SDP answer below
      var data = roomSnapshot.data() as Map<String, dynamic>;
      print('Got offer $data');
      var offer = data['offer'];
      await peerConnection?.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );
      var answer = await peerConnection!.createAnswer();
      print('Created Answer $answer');

      await peerConnection!.setLocalDescription(answer);

      Map<String, dynamic> roomWithAnswer = {
        'answer': {'type': answer.type, 'sdp': answer.sdp}
      };

      await roomRef.update(roomWithAnswer);
      // Finished creating SDP answer

      // Listening for remote ICE candidates below
      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((document) {
          var data = document.doc.data() as Map<String, dynamic>;
          print(data);
          print('Got new remote ICE candidate: $data');
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        });
      });
    }
  }

  Future<void> hangUp() async {
    localStream!.dispose();
    remoteStream?.dispose();
    if (peerConnection != null) {
      await peerConnection!.close();
      peerConnection = null;
    }
    if (roomId != null) {
      var db = FirebaseFirestore.instance;
      var roomRef = db.collection('rooms').doc(roomId);
      var calleeCandidates = await roomRef.collection('calleeCandidates').get();
      for (var document in calleeCandidates.docs) {
        await document.reference.delete();
      }

      var callerCandidates = await roomRef.collection('callerCandidates').get();
      for (var document in callerCandidates.docs) {
        await document.reference.delete();
      }
      await roomRef.delete();
    }
    peerConnection?.onAddStream = (MediaStream stream) {
      print("Add remote stream: ${stream.id}");
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
      remoteStream?.getAudioTracks().forEach((track) {
        track.enabled = true;
        print('Remote audio track: ${track.id}, kind: ${track
            .kind}, enabled: ${track.enabled}');
      });
    };

    peerConnection?.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        remoteStream = event.streams[0];
        print('Remote stream added: ${remoteStream?.id}');
        remoteStream?.getAudioTracks().forEach((track) {
          // track.enabled=true;
          print('Remote audio track: ${track.id}, kind: ${track
              .kind}, enabled: ${track.enabled}');
        });
        onAddRemoteStream?.call(remoteStream!);
      }
    };
  }

    Future<void> listenForIncomingCalls(String roomId) async {
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference roomRef = db.collection('rooms').doc(roomId);
      var roomSnapshot = await roomRef.get();

      if (roomSnapshot.exists) {
        peerConnection = await createPeerConnection(configuration);
        registerPeerConnectionListeners();

        localStream?.getTracks().forEach((track) {
          peerConnection?.addTrack(track, localStream!);
        });

        var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
        peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
          if (candidate != null) {
            calleeCandidatesCollection.add(candidate.toMap());
          }
        };

        peerConnection?.onTrack = (RTCTrackEvent event) {
          event.streams[0].getTracks().forEach((track) {
            remoteStream?.addTrack(track);
          });
          remoteStream?.getAudioTracks().forEach((track) {
            track.enabled = true; // Ensure the track is enabled
            print('Remote audio track: ${track.id}, enabled: ${track.enabled}');
          });
          onAddRemoteStream?.call(remoteStream!);
        };

        var data = roomSnapshot.data() as Map<String, dynamic>;
        var offer = data['offer'];
        await peerConnection?.setRemoteDescription(
          RTCSessionDescription(offer['sdp'], offer['type']),
        );
        var answer = await peerConnection!.createAnswer();
        await peerConnection!.setLocalDescription(answer);

        await roomRef.update(
            {'answer': {'type': answer.type, 'sdp': answer.sdp}});

        roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
          for (var document in snapshot.docChanges) {
            var data = document.doc.data() as Map<String, dynamic>;
            peerConnection!.addCandidate(
              RTCIceCandidate(
                  data['candidate'], data['sdpMid'], data['sdpMLineIndex']),
            );
          }
        });
      }
    }
  }