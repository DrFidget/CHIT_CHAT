import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  String? creatorId;
  String? memberId;
  String? roomName;
  String? roomId;
  String? roomType;
  Timestamp? timeStamp;
  List<dynamic>? members;

  ChatRoom({
    this.creatorId,
    this.memberId,
    this.roomName,
    this.roomId,
    this.timeStamp,
    this.members,
    this.roomType,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      creatorId: json['creatorId'],
      memberId: json['memberId'],
      roomName: json['roomName'],
      roomId: json['roomId'],
      timeStamp: json['timeStamp'],
      members: json['members'],
      roomType: json['roomType'],
    );
  }
  void printDetails() {
    print('Room Details:');
    print('Creator ID: $creatorId');
    print('Member ID: $memberId');
    print('Room Name: $roomName');
    print('Room ID: $roomId');
    print('Time Stamp: $timeStamp');
    print('Members: $members');
    print('Room Type: $roomType');
  }
}
