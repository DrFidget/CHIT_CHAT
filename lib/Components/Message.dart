import 'package:flutter/material.dart';
import 'package:ourappfyp/APIS/api_service.dart'; // Make sure to import your API service

class MessageWidget extends StatefulWidget {
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
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  String? translatedText;
  String sourceLang = 'ur';
  String targetLang = 'en';

  Future<void> _translateMessage(
      String sourceLanguage, String targetLanguage) async {
    try {
      // Call the translation API
      String translation = await ApiService.translateText(
        widget.text,
        sourceLanguage,
        targetLanguage,
      );

      // Update the state with the translated text
      setState(() {
        translatedText = translation;
        sourceLang = sourceLanguage;
        targetLang = targetLanguage;
      });

      // Print the translated text to the console
      print('Translated Text: $translation');
    } catch (error) {
      print('Error translating text: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.8;

    return Container(
      alignment:
          widget.alignLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          widget.callback();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: widget.alignLeft
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: widget.alignLeft
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: [
                    if (!widget.alignLeft)
                      Flexible(
                        child: Text(
                          translatedText ?? widget.text,
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: widget.textColor,
                        size: 20,
                      ),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          child: TextButton(
                            onPressed: () {
                              // Toggle translation direction between English and Urdu
                              if (sourceLang == 'en' && targetLang == 'ur') {
                                _translateMessage('ur', 'en');
                              } else {
                                _translateMessage('en', 'ur');
                              }
                              Navigator.pop(context); // Close the menu
                            },
                            child: Row(
                              children: [
                                Icon(Icons.translate, size: 18),
                                SizedBox(width: 8),
                                Text(
                                    'Translate to ${sourceLang == 'en' ? 'English' : 'Urdu'}',
                                    style: TextStyle(fontSize: 14)),
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
                                Icon(Icons.volume_up, size: 18),
                                SizedBox(width: 8),
                                Text('Convert to Speech',
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.alignLeft)
                      Flexible(
                        child: Text(
                          translatedText ?? widget.text,
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${widget.dateTime.hour}:${widget.dateTime.minute}',
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
