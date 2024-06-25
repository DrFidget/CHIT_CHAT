import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class ApiService {
  static const String baseUrl = 'https://fypserver.onrender.com';

  static Future<String> transcribeAudio(
      String languageCode, List<int> audioBytes) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transcribe'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'audio': base64Encode(audioBytes), 'languageCode': languageCode}),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return decodedResponse['transcription'];
      } else {
        throw Exception('Failed to transcribe audio: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to transcribe audio: $e');
    }
  }

  static Future<String> translateText(
      String text, String sourceLanguage, String targetLanguage) async {
    var uri = Uri.parse('$baseUrl/translate');
    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'text': text,
        'sourceLanguage': sourceLanguage,
        'targetLanguage': targetLanguage,
      }),
    );

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      return decodedResponse['translation'];
    } else {
      throw Exception('Failed to translate text');
    }
  }

  static Future<Uint8List> synthesizeTextToSpeech(String text,
      {String languageCode = 'en-US'}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/synthesize'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text, 'languageCode': languageCode}),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception(
            'Failed to synthesize text to speech: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to synthesize text to speech: $e');
    }
  }

  static Future<String> uploadFile(File file) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/storage/file'));
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.transform(utf8.decoder).join();
        var decodedResponse = jsonDecode(responseData);
        return decodedResponse['fileUrl'];
      } else {
        throw Exception('Failed to upload file: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  static Future<String> transcribeFromUrl(String audioUrl,
      {String languageCode = 'en-US'}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transcribeFromUrl'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'audioUrl': audioUrl, 'languageCode': languageCode}),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return decodedResponse['transcription'];
      } else {
        throw Exception(
            'Failed to transcribe audio from URL: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to transcribe audio from URL: $e');
    }
  }
}
