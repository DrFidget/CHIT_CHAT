import 'package:flutter/material.dart';
import 'package:ourappfyp/APIS/api_service.dart';
import 'package:ourappfyp/Components/audioplayerAI.dart';
import 'package:ourappfyp/services/UserCollectionFireStore/usersCollection.dart';

class MessageForGroup extends StatefulWidget {
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final bool alignLeft;
  final Function callback;
  final DateTime dateTime;
  final String userWhoSent;

  const MessageForGroup({
    Key? key,
    required this.backgroundColor,
    required this.textColor,
    required this.text,
    required this.alignLeft,
    required this.callback,
    required this.dateTime,
    required this.userWhoSent,
  }) : super(key: key);

  @override
  _MessageForGroupState createState() => _MessageForGroupState();
}

class _MessageForGroupState extends State<MessageForGroup> {
  String? translatedText;
  String sourceLang = 'ur';
  String targetLang = 'en';
  bool isConvertedToVoice = false;
  String URL = '';
  dynamic User = {'name': "", 'email': ""};

  @override
  void initState() {
    super.initState();
    setUserFromID();
  }

  void setUserFromID() async {
    UserFirestoreService userService = UserFirestoreService();
    dynamic user =
        await userService.getUserNameAndEmailById(widget.userWhoSent);
    setState(() {
      User = user;
    });
  }

  Future<void> _translateMessage(
      String sourceLanguage, String targetLanguage) async {
    try {
      String translation = await ApiService.translateText(
          widget.text, sourceLanguage, targetLanguage);
      setState(() {
        translatedText = translation;
        sourceLang = sourceLanguage;
        targetLang = targetLanguage;
      });
    } catch (error) {
      print('Error translating text: $error');
    }
  }

  Future<void> _synthesizeSpeech(String text, String languageCode) async {
    try {
      URL = await ApiService.synthesizeSpeech(text, languageCode: languageCode);
      setState(() {
        isConvertedToVoice = true;
      });
    } catch (error) {
      print('Error synthesizing speech: $error');
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.translate),
              title: Text(
                  'Translate to ${sourceLang == 'en' ? 'English' : 'Urdu'}'),
              onTap: () {
                if (sourceLang == 'en' && targetLang == 'ur') {
                  _translateMessage('ur', 'en');
                } else {
                  _translateMessage('en', 'ur');
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.volume_up),
              title: Text('Convert to Speech'),
              onTap: () {
                _synthesizeSpeech(
                    widget.text, sourceLang == 'ur' ? 'en-US' : 'ur-PK');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
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
        onLongPress: () {
          _showBottomSheet(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: widget.alignLeft
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Text(
                User['name'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 4),
              Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  translatedText ?? widget.text,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: 16,
                  ),
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
              if (isConvertedToVoice)
                AudioPLayerForAi(
                  dateTime: widget.dateTime,
                  backgroundColor: widget.backgroundColor,
                  textColor: widget.textColor,
                  audioUrl: URL,
                  alignLeft: widget.alignLeft,
                  callback: () => {},
                ),
            ],
          ),
        ),
      ),
    );
  }
}
