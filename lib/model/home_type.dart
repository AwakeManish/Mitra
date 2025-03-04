import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/feature/chatbot_feature.dart';
import '../screen/feature/aqi_feature.dart';
import '../screen/feature/health_widget_feature.dart'; // Import Health Widget screen

enum HomeType { aiChatBot, aiAQICalculator, healthWidget }

extension MyHomeType on HomeType {
  // Title
  String get title => switch (this) {
        HomeType.aiChatBot => 'ChatBot',
        HomeType.aiAQICalculator => 'AQI Calculator',
        HomeType.healthWidget => 'Health Widget', // Add title for Health Widget
      };

  // Lottie animation file
  String get lottie => switch (this) {
        HomeType.aiChatBot => 'ai_hand_waving.json',
        HomeType.aiAQICalculator => 'ai_aqi_calculator.json',
        HomeType.healthWidget =>
          'health_widget.json', // Add animation for Health Widget
      };

  // Alignment for layout
  bool get leftAlign => switch (this) {
        HomeType.aiChatBot => true,
        HomeType.aiAQICalculator => false,
        HomeType.healthWidget => true, // Set alignment for Health Widget
      };

  // Padding for layout
  EdgeInsets get padding => switch (this) {
        HomeType.aiChatBot => EdgeInsets.zero,
        HomeType.aiAQICalculator => const EdgeInsets.all(10),
        HomeType.healthWidget => const EdgeInsets.symmetric(
            horizontal: 15), // Set padding for Health Widget
      };

  // Navigation for each feature
  VoidCallback get onTap => switch (this) {
        HomeType.aiChatBot => () => Get.to(() => const ChatBotFeature()),
        HomeType.aiAQICalculator => () => Get.to(() => const AQIFeature()),
        HomeType.healthWidget => () => Get.to(() =>
            const HealthWidgetFeature()), // Add navigation for Health Widget
      };
}
