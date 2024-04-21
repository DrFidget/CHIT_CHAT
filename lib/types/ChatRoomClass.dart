import 'dart:ffi';

class ChatRoom {
  String? creatorId;
  String? memberId;
  String? roomName;
  String? roomId;
  String? timeStamp;

  ChatRoom({
    this.creatorId,
    this.memberId,
    this.roomName,
    this.roomId,
    this.timeStamp,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      creatorId: json['creatorId'],
      memberId: json['memberId'],
      roomName: json['roomName'],
      roomId: json['roomId'],
      timeStamp: json['timeStamp'],
    );
  }
  void printDetails() {
    print('Room Details:');
    print('Creator ID: $creatorId');
    print('Member ID: $memberId');
    print('Room Name: $roomName');
    print('Room ID: $roomId');
    print('Time Stamp: $timeStamp');
  }
}
