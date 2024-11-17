import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/feature/chatbot_feature.dart';
import '../screen/feature/image_feature.dart';
import '../screen/feature/translator_feature.dart';
import '../screen/feature/aqi_feature.dart'; // Import AQI feature

enum HomeType {
  aiChatBot,
  aiImage,
  aiTranslator,
  aiAQICalculator
} // Add AQI Calculator

extension MyHomeType on HomeType {
  // Title
  String get title => switch (this) {
        HomeType.aiChatBot => 'AI ChatBot',
        HomeType.aiImage => 'AI Image Creator',
        HomeType.aiTranslator => 'Language Translator',
        HomeType.aiAQICalculator => 'AQI Calculator', // AQI title
      };

  // Lottie animation file
  String get lottie => switch (this) {
        HomeType.aiChatBot => 'ai_hand_waving.json',
        HomeType.aiImage => 'ai_play.json',
        HomeType.aiTranslator => 'ai_ask_me.json',
        HomeType.aiAQICalculator => 'ai_aqi_calculator.json', // AQI animation
      };

  // Alignment for layout
  bool get leftAlign => switch (this) {
        HomeType.aiChatBot => true,
        HomeType.aiImage => false,
        HomeType.aiTranslator => true,
        HomeType.aiAQICalculator => false, // Set alignment for AQI
      };

  // Padding for layout
  EdgeInsets get padding => switch (this) {
        HomeType.aiChatBot => EdgeInsets.zero,
        HomeType.aiImage => const EdgeInsets.all(20),
        HomeType.aiTranslator => EdgeInsets.zero,
        HomeType.aiAQICalculator =>
          const EdgeInsets.all(10), // Set padding for AQI
      };

  // Navigation for each feature
  VoidCallback get onTap => switch (this) {
        HomeType.aiChatBot => () => Get.to(() => const ChatBotFeature()),
        HomeType.aiImage => () => Get.to(() => const ImageFeature()),
        HomeType.aiTranslator => () => Get.to(() => const TranslatorFeature()),
        HomeType.aiAQICalculator => () =>
            Get.to(() => const AQIFeature()), // AQI navigation
      };
}
