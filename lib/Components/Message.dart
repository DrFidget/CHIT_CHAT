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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        text,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert, // Using three dots icon for menu
                        color:
                            Colors.white, // Customize the icon color as needed
                        size: 20, // Adjust the size of the icon
                      ),
                      iconSize:
                          18, // Adjust the size of the PopupMenuButton icon
                      offset: Offset(
                          0, 0), // Adjust the position of the menu if needed
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          child: TextButton(
                            onPressed: () {
                              // Implement translate functionality
                              Navigator.pop(context); // Close the menu
                            },
                            child: Row(
                              children: [
                                Icon(Icons.translate,
                                    size: 18), // Customize size if needed
                                // SizedBox(width: 8), // Adjust spacing as needed
                                Text('Translate',
                                    style: TextStyle(
                                        fontSize:
                                            14)), // Adjust fontSize as needed
                              ],
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          child: TextButton(
                            onPressed: () {
                              // Implement text-to-speech functionality
                              Navigator.pop(context); // Close the menu
                            },
                            child: Row(
                              children: [
                                Icon(Icons.volume_up,
                                    size: 18), // Customize size if needed
                                SizedBox(width: 8), // Adjust spacing as needed
                                Text('Convert to Speech',
                                    style: TextStyle(
                                        fontSize:
                                            14)), // Adjust fontSize as needed
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
