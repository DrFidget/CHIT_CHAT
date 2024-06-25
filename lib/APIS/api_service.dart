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
}
