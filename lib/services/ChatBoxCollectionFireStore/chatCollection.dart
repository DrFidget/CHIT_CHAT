import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ourappfyp/types/ChatRoomClass.dart';

String getFormattedTimestamp() {
  Timestamp timestamp = Timestamp.now();
  DateTime date = timestamp.toDate();

  var format = DateFormat('dd-MM-yyyy:HH:mm:ss');
  String formattedDate = format.format(date);

  return formattedDate;
}

class chatBoxFirestoreService {
  final CollectionReference chatBox =
      FirebaseFirestore.instance.collection('chatRooms');

  Future<void> addChatRoom(String creatorID, String memberId) {
    return chatBox.add({
      'creatorId': creatorID,
      'memberId': memberId,
      'timeStamp': getFormattedTimestamp(),
    });
  }

  Future<List<ChatRoom>> getAllChatRooms() async {
    try {
      QuerySnapshot querySnapshot = await chatBox.get();
      List<ChatRoom> chatRoomList = [];
      for (var documentSnapshot in querySnapshot.docs) {
        ChatRoom chatRoom =
            ChatRoom.fromJson(documentSnapshot.data() as Map<String, dynamic>);
        chatRoomList.add(chatRoom);
      }
      for (var x in chatRoomList) {
        print("-----------------");
        x.printDetails();
        print("-----------------");
      }

      return chatRoomList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<ChatRoom>> getAllChatRoomsByCreatorId(String creatorId) async {
    print("id: " + creatorId);
    try {
      QuerySnapshot querySnapshot =
          await chatBox.where('members', arrayContains: creatorId).get();
      List<ChatRoom> chatRoomList = [];
      for (var documentSnapshot in querySnapshot.docs) {
        ChatRoom chatRoom =
            ChatRoom.fromJson(documentSnapshot.data() as Map<String, dynamic>);
        String id = documentSnapshot.id as String;
        chatRoom.roomId = id;
        chatRoomList.add(chatRoom);
      }
      for (var x in chatRoomList) {
        print("-----------------");
        x.printDetails();
        print("-----------------");
      }
      return chatRoomList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> deleteChatRoom(String chatRoomId) {
    return chatBox.doc(chatRoomId).delete();
  }

  Future<void> populateDummyChatRooms() async {
    // Generate dummy data for chat rooms
    List<Map<String, dynamic>> dummyChatRooms = [
      {
        'creatorId': '22KDDtL7ebpFluEyXOKE',
        'memberId': 'HMV9ZwJWdMdIgaeTopgc',
        'members': ['22KDDtL7ebpFluEyXOKE', 'HMV9ZwJWdMdIgaeTopgc'],
        'timeStamp': getFormattedTimestamp(),
      },
      {
        'creatorId': '22KDDtL7ebpFluEyXOKE',
        'memberId': 'HtxZc2ylJOFXzIje6UZd',
        'members': ['22KDDtL7ebpFluEyXOKE', 'HtxZc2ylJOFXzIje6UZd'],
        'timeStamp': getFormattedTimestamp(),
      },
      {
        'creatorId': '22KDDtL7ebpFluEyXOKE',
        'memberId': 'QyODPvqLH06V4EZkh1nf',
        'members': ['22KDDtL7ebpFluEyXOKE', 'QyODPvqLH06V4EZkh1nf'],
        'timeStamp': getFormattedTimestamp(),
      },
      {
        'creatorId': '22KDDtL7ebpFluEyXOKE',
        'memberId': 'hlxivmxrZZGfxgMikW61',
        'members': ['22KDDtL7ebpFluEyXOKE', 'hlxivmxrZZGfxgMikW61'],
        'timeStamp': getFormattedTimestamp(),
      },
      {
        'creatorId': '22KDDtL7ebpFluEyXOKE',
        'memberId': 'kOgBHK6DoEWGPHx8F2av',
        'members': ['22KDDtL7ebpFluEyXOKE', 'kOgBHK6DoEWGPHx8F2av'],
        'timeStamp': getFormattedTimestamp(),
      },
    ];

    try {
      for (var data in dummyChatRooms) {
        await chatBox.add(data);
      }
      print('Dummy chat rooms added successfully.');
    } catch (e) {
      print('Error adding dummy chat rooms: $e');
    }
  }
}
//https://chat.openai.com/c/d51cf2a7-29b8-4e37-bca7-0057f6ec9cfb