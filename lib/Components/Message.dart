import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final bool alignLeft;
  final Function callback;

  const MessageWidget({
    Key? key,
    required this.backgroundColor,
    required this.textColor,
    required this.text,
    required this.alignLeft,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      alignment: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          callback();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
