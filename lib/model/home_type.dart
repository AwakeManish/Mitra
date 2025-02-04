import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/feature/chatbot_feature.dart';
import '../screen/feature/aqi_feature.dart';

enum HomeType { aiChatBot, aiAQICalculator }

extension MyHomeType on HomeType {
  // Title
  String get title => switch (this) {
        HomeType.aiChatBot => 'AI ChatBot',
        HomeType.aiAQICalculator => 'AQI Calculator',
      };

  // Lottie animation file
  String get lottie => switch (this) {
        HomeType.aiChatBot => 'ai_hand_waving.json',
        HomeType.aiAQICalculator => 'ai_aqi_calculator.json',
      };

  // Alignment for layout
  bool get leftAlign => switch (this) {
        HomeType.aiChatBot => true,
        HomeType.aiAQICalculator => false,
      };

  // Padding for layout
  EdgeInsets get padding => switch (this) {
        HomeType.aiChatBot => EdgeInsets.zero,
        HomeType.aiAQICalculator => const EdgeInsets.all(10),
      };

  // Navigation for each feature
  VoidCallback get onTap => switch (this) {
        HomeType.aiChatBot => () => Get.to(() => const ChatBotFeature()),
        HomeType.aiAQICalculator => () => Get.to(() => const AQIFeature()),
      };
}
