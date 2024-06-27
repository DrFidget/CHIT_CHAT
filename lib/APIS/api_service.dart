import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class ApiService {
  static const String baseUrl = 'https://fypserver.onrender.com';

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

  static Future<String> synthesizeSpeech(String text,
      {String languageCode = 'en-US'}) async {
    var uri = Uri.parse('$baseUrl/synthesize');
    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'text': text,
        'languageCode': languageCode,
      }),
    );

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      return decodedResponse['fileUrl'];
    } else {
      throw Exception('Failed to synthesize speech');
    }
  }
}
