import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final bool alignLeft;
  final Function callback;
  final DateTime dateTime;

  const MessageWidget({
    Key? key,
    required this.backgroundColor,
    required this.textColor,
    required this.text,
    required this.alignLeft,
    required this.callback,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxWidth =
        MediaQuery.of(context).size.width * 0.8; // Adjust percentage as needed

    return Container(
      alignment: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          callback();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(
                      20), // Increased border radius for rounder shape
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                  height:
                      4), // Adding some space between the main text and the timestamp
              Text(
                '${dateTime.hour}:${dateTime.minute}', // Displaying only time for simplicity, you can format the DateTime as needed
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
