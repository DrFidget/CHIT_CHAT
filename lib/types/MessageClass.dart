import 'package:cloud_firestore/cloud_firestore.dart';

class MessageClass {
  String? senderID;
  String? reciverID;
  Timestamp? timeStamp;
  String? message;
  String? type;

  MessageClass(
    this.senderID,
    this.reciverID,
    this.timeStamp,
    this.message,
    this.type,
  );
  MessageClass.fromJson(Map<String, dynamic> json) {
    senderID = json['senderID'];
    reciverID = json['reciverID'];
    timeStamp = json['timeStamp'];
    message = json['message'];
    type = json['type'];
  }
  void printMessageDetails(MessageClass message) {
    print('Sender ID: ${message.senderID}');
    print('Reciver ID: ${message.reciverID}');
    print('Time Stamp: ${message.timeStamp}');
    print('Message: ${message.message}');
    print('Type: ${message.type}');
  }
}
