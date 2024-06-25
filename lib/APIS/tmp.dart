// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// // import 'package:file_picker/file_picker.dart';
// import 'dart:typed_data';
// import 'package:audioplayers/audioplayers.dart';
// import 'api_service.dart'; // Import the ApiService

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ApiTestingDemo(),
//     );
//   }
// }

// class ApiTestingDemo extends StatefulWidget {
//   @override
//   _ApiTestingDemoState createState() => _ApiTestingDemoState();
// }

// class _ApiTestingDemoState extends State<ApiTestingDemo> {
//   String _transcription = '';
//   String _translation = '';
//   Uint8List? _synthesizedAudio;
//   TextEditingController _textInputController = TextEditingController();
//   TextEditingController _translationInputController = TextEditingController();
//   String _languageCode = 'en-US';
//   String _sourceLanguage = 'en';
//   String _targetLanguage = 'ur';
//   AudioPlayer _audioPlayer = AudioPlayer();

//   // Future<void> _transcribe() async {
//   //   // FilePickerResult? result =
//   //   //     await FilePicker.platform.pickFiles(type: FileType.audio);
//   //   // if (result != null) {
//   //   //   File audioFile = File(result.files.single.path!);
//   //   //   String languageCode = 'en-US';
//   //   //   String transcription =
//   //   //       await ApiService.transcribeAudio(audioFile, languageCode);
//   //   //   setState(() {
//   //   //     _transcription = transcription;
//   //   //   });
//   //   // } else {
//   //   //   // User canceled the picker
//   //   // }
//   // }

//   // Future<void> _synthesize() async {
//   //   String text = _textInputController.text;
//   //   String languageCode = _languageCode;
//   //   Uint8List audioContent =
//   //       // await ApiService.synthesizeSpeech(text, languageCode);
//   //   // setState(() {
//   //   //   _synthesizedAudio = audioContent;
//   //   // });

//   //   // Save audio to a file and play it
//   //   final directory = await getApplicationDocumentsDirectory();
//   //   final audioFile = File('${directory.path}/output.mp3');
//   //   await audioFile.writeAsBytes(audioContent);
//   //   // await _audioPlayer.play(audioFile.path, isLocal: true);
//   // }

//   // Future<void> _translate() async {
//   //   String text = _translationInputController.text;
//   //   String sourceLanguage = _sourceLanguage;
//   //   String targetLanguage = _targetLanguage;
//   //   String translation =
//   //       await ApiService.translateText(text, sourceLanguage, targetLanguage);
//   //   setState(() {
//   //     _translation = translation;
//   //   });
//   // }

//   @override
//   void dispose() {
//     _textInputController.dispose();
//     _translationInputController.dispose();
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Cloud APIs Demo'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 'Speech-to-Text',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               ElevatedButton(
//                 onPressed: _transcribe,
//                 child: Text('Transcribe Audio'),
//               ),
//               TextField(
//                 controller: TextEditingController(text: _transcription),
//                 maxLines: 6,
//                 readOnly: true,
//                 decoration: InputDecoration(
//                   hintText: 'Transcription will appear here',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 'Text-to-Speech',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               TextField(
//                 controller: _textInputController,
//                 maxLines: 4,
//                 decoration: InputDecoration(
//                   hintText: 'Enter text to synthesize',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               DropdownButton<String>(
//                 value: _languageCode,
//                 items: <String>['en-US', 'ur-PK'].map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _languageCode = newValue!;
//                   });
//                 },
//               ),
//               ElevatedButton(
//                 onPressed: _synthesize,
//                 child: Text('Synthesize Speech'),
//               ),
//               if (_synthesizedAudio != null)
//                 Text('Synthesized audio is playing...'),
//               SizedBox(height: 20),
//               Text(
//                 'Translation',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               TextField(
//                 controller: _translationInputController,
//                 maxLines: 4,
//                 decoration: InputDecoration(
//                   hintText: 'Enter text to translate',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               DropdownButton<String>(
//                 value: _sourceLanguage,
//                 items: <String>['en', 'ur'].map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _sourceLanguage = newValue!;
//                   });
//                 },
//               ),
//               DropdownButton<String>(
//                 value: _targetLanguage,
//                 items: <String>['en', 'ur'].map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _targetLanguage = newValue!;
//                   });
//                 },
//               ),
//               ElevatedButton(
//                 onPressed: _translate,
//                 child: Text('Translate Text'),
//               ),
//               TextField(
//                 controller: TextEditingController(text: _translation),
//                 maxLines: 4,
//                 readOnly: true,
//                 decoration: InputDecoration(
//                   hintText: 'Translation will appear here',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
