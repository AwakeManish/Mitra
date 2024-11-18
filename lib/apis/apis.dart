import 'dart:convert';
import 'dart:developer';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart';
import 'package:translator_plus/translator_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class APIs {
  // Access the API key
  static final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  // Get answer from Google Gemini AI
  static Future<String> getAnswer(String question) async {
    try {
      log('API Key: $apiKey');

      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: apiKey,
      );

      final content = [Content.text(question)];
      final res = await model.generateContent(content, safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
      ]);

      log('Response: ${res.text}');

      return res.text!;
    } catch (e) {
      log('getAnswerGeminiError: $e');
      return 'Something went wrong (Try again later)';
    }
  }

//Image generation
  static Future<List<String>> searchAiImages(String prompt) async {
    try {
      final res =
          await get(Uri.parse('https://lexica.art/api/v1/search?q=$prompt'));

      final data = jsonDecode(res.body);

      //
      return List.from(data['images']).map((e) => e['src'].toString()).toList();
    } catch (e) {
      log('searchAiImagesE: $e');
      return [];
    }
  }

//google translation
  static Future<String> googleTranslate(
      {required String from, required String to, required String text}) async {
    try {
      final res = await GoogleTranslator().translate(text, from: from, to: to);

      return res.text;
    } catch (e) {
      log('googleTranslateE: $e ');
      return 'Something went wrong!';
    }
  }

// Fetch AQI data from WAQI API
  static Future<Map<String, dynamic>> fetchAQI(String city) async {
    final apiKey = dotenv.env['AQI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      log('AQI API key is missing.');
      return {'error': 'API key missing'};
    }

    final encodedCity = Uri.encodeComponent(city);
    final url =
        Uri.parse('https://api.waqi.info/feed/$encodedCity/?token=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'ok') {
          return data['data'];
        } else {
          // Handle different types of error messages
          String errorMessage;
          if (data['data'] is Map && data['data']['message'] != null) {
            errorMessage = data['data']['message'];
          } else if (data['data'] is String) {
            errorMessage = data['data'];
          } else if (data['message'] != null) {
            errorMessage = data['message'];
          } else {
            errorMessage = 'Unknown error';
          }
          log('Failed to fetch AQI data: $errorMessage');
          return {'error': errorMessage};
        }
      } else {
        log('Failed to fetch AQI data: ${response.statusCode}');
        return {'error': 'Failed to fetch AQI data: ${response.statusCode}'};
      }
    } catch (e) {
      log('fetchAQIError: $e');
      return {'error': 'An error occurred: $e'};
    }
  }
}
