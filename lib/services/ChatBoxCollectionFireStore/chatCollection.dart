import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ourappfyp/types/ChatRoomClass.dart';

class chatBoxFirestoreService {
  final CollectionReference chatBox =
      FirebaseFirestore.instance.collection('chatRooms');

  Future<void> addChatRoom(String creatorID, String memberId) {
    return chatBox.add({
      'creatorId': creatorID,
      'memberId': memberId,
      'timeStamp': Timestamp.now(),
      'imageLink':
          "https://firebasestorage.googleapis.com/v0/b/chitchat-425ea.appspot.com/o/images%2Fimage_1719166174077.jpg?alt=media&token=8e05db3f-5748-4f16-97e2-adacebdbbae6",
      'description': "",
    });
  }

  Future<void> updateChatRoomTimestamp(String id) {
    return chatBox.doc(id).update({
      'timeStamp': Timestamp.now(),
    });
  }

  Future<void> createGroupChat(String loggedInUserId,
      List<String> selectedUserIds, String groupName) async {
    print(groupName);
    print(loggedInUserId);
    print(selectedUserIds);

    var allMembers = List<String>.from(selectedUserIds);
    allMembers.add(loggedInUserId);

    await chatBox.add({
      'creatorId': loggedInUserId,
      'members': allMembers,
      'name': groupName,
      'timeStamp': Timestamp.now(),
      'memberId': '',
      'roomType': "group",
      'imageLink':
          "https://firebasestorage.googleapis.com/v0/b/chitchat-425ea.appspot.com/o/images%2Fimage_1719166174077.jpg?alt=media&token=8e05db3f-5748-4f16-97e2-adacebdbbae6",
      'description': "",
    });
  }

  Future<void> createChatRoom(String CreatorID, String MemberID) {
    if (CreatorID.isEmpty || MemberID.isEmpty) {
      return Future.error("CreatorID or MemberID is empty");
    }
    var sortedList = <String>[];
    sortedList.add(CreatorID);
    sortedList.add(MemberID);
    sortedList.sort();
    var name = sortedList[0] + sortedList[1];

    // Check if a chat room with the same name already exists
    return chatBox.where('name', isEqualTo: name).get().then((querySnapshot) {
      if (querySnapshot.size > 0) {
        // If a chat room with the same name already exists, do not create a new one
        print('Chat room with name $name already exists');
      } else {
        // If no chat room with the same name exists, create a new one
        chatBox.add({
          'creatorId': CreatorID,
          'memberId': MemberID,
          'members': sortedList,
          'name': name,
          'timeStamp': Timestamp.now(),
          'roomType': "dm"
        });
      }
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
      QuerySnapshot querySnapshot = await chatBox
          .where('members', arrayContains: creatorId)
          .orderBy('timeStamp', descending: false)
          .get();
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
        'timeStamp': Timestamp.now(),
      },
      {
        'creatorId': '22KDDtL7ebpFluEyXOKE',
        'memberId': 'HtxZc2ylJOFXzIje6UZd',
        'members': ['22KDDtL7ebpFluEyXOKE', 'HtxZc2ylJOFXzIje6UZd'],
        'timeStamp': Timestamp.now(),
      },
      {
        'creatorId': '22KDDtL7ebpFluEyXOKE',
        'memberId': 'QyODPvqLH06V4EZkh1nf',
        'members': ['22KDDtL7ebpFluEyXOKE', 'QyODPvqLH06V4EZkh1nf'],
        'timeStamp': Timestamp.now(),
      },
      {
        'creatorId': '22KDDtL7ebpFluEyXOKE',
        'memberId': 'hlxivmxrZZGfxgMikW61',
        'members': ['22KDDtL7ebpFluEyXOKE', 'hlxivmxrZZGfxgMikW61'],
        'timeStamp': Timestamp.now(),
      },
      {
        'creatorId': '22KDDtL7ebpFluEyXOKE',
        'memberId': 'kOgBHK6DoEWGPHx8F2av',
        'members': ['22KDDtL7ebpFluEyXOKE', 'kOgBHK6DoEWGPHx8F2av'],
        'timeStamp': Timestamp.now(),
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

  Stream<QuerySnapshot> getChatRoomsOfLoggedInPerson(String loggedInID) {
    return chatBox
        .where('members', arrayContains: loggedInID)
        .where('roomType', isEqualTo: 'dm')
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getGroupChatRoomsOfLoggedInPerson(String loggedInID) {
    return chatBox
        .where('members', arrayContains: loggedInID)
        .where('roomType', isEqualTo: 'group')
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

  Future<void> leaveGroup(String groupID, String loggedInUserID) async {
    try {
      DocumentSnapshot doc = await chatBox.doc(groupID).get();
      if (doc.exists) {
        List<dynamic> members = doc['members'];
        String creatorID = doc['creatorId'];
        members.remove(loggedInUserID);
        if (loggedInUserID == creatorID) {
          await chatBox.doc(groupID).delete();
        }

        await chatBox.doc(groupID).update({
          'members': members,
          'timeStamp': Timestamp.now(),
        });
        print('User $loggedInUserID has left the group $groupID');
      } else {
        print('Chat room with ID $groupID does not exist.');
      }
    } catch (e) {
      print('Error leaving group: $e');
    }
  }
}
//https://chat.openai.com/c/d51cf2a7-29b8-4e37-bca7-0057f6ec9cfb