import 'package:flutter/material.dart';

class ChattingPage extends StatefulWidget {
  final String SenderId;
  final String ReceiverId;
  final String ReceiverName;
  final String ChatRoomId;

  const ChattingPage(
      {super.key,
      required this.SenderId,
      required this.ReceiverId,
      required this.ReceiverName,
      required this.ChatRoomId});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
