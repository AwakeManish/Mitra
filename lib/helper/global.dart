import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//app name
const appName = 'Mitra';

//media query to store size of device screen
late Size mq;

//  Google Gemini API Key - https://aistudio.google.com/app/apikey

String apiKey = dotenv.env['API_KEY'] ?? '';
