import 'dart:convert';
import 'dart:developer';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart';
import 'package:translator_plus/translator_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIs {
  // Access the API key
  static final String apiKey = dotenv.env['API_KEY'] ?? '';

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

  //get answer from chat gpt
  // static Future<String> getAnswer(String question) async {
  //   try {
  //     log('api key: $apiKey');

  //     //
  //     final res =
  //         await post(Uri.parse('https://api.openai.com/v1/chat/completions'),

  //             //headers
  //             headers: {
  //               HttpHeaders.contentTypeHeader: 'application/json',
  //               HttpHeaders.authorizationHeader: 'Bearer $apiKey'
  //             },

  //             //body
  //             body: jsonEncode({
  //               "model": "gpt-3.5-turbo",
  //               "max_tokens": 2000,
  //               "temperature": 0,
  //               "messages": [
  //                 {"role": "user", "content": question},
  //               ]
  //             }));

  //     final data = jsonDecode(res.body);

  //     log('res: $data');
  //     return data['choices'][0]['message']['content'];
  //   } catch (e) {
  //     log('getAnswerGptE: $e');
  //     return 'Something went wrong (Try again in sometime)';
  //   }
  // }
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
}
