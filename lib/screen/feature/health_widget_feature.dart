import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_usage/app_usage.dart'; // For tracking app usage
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class HealthWidgetFeature extends StatefulWidget {
  const HealthWidgetFeature({super.key});

  @override
  State<HealthWidgetFeature> createState() => _HealthWidgetFeatureState();
}

class _HealthWidgetFeatureState extends State<HealthWidgetFeature> {
  String _stepCount = 'Loading...';
  String _screenTime = 'Loading...';

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  // Check and request necessary permissions during initialization
  Future<void> _checkAndRequestPermissions() async {
    if (Platform.isAndroid) {
      // Check and request Physical Activity permission
      if (await Permission.activityRecognition.isDenied) {
        await Permission.activityRecognition.request();
      }

      // Check and redirect to Usage Access settings if not granted
      bool usagePermissionGranted = await _isUsageAccessGranted();
      if (!usagePermissionGranted) {
        await _redirectToUsageAccessSettings();
      }

      // Fetch step count and screen time after permissions are handled
      _fetchStepCount();
      _fetchScreenTime();
    } else {
      setState(() {
        _stepCount = 'Not supported on this platform.';
        _screenTime = 'Not available on iOS.';
      });
    }
  }

  // Check if Usage Access permission is granted
  Future<bool> _isUsageAccessGranted() async {
    try {
      DateTime startDate = DateTime.now().subtract(const Duration(days: 1));
      DateTime endDate = DateTime.now();
      await AppUsage().getAppUsage(startDate, endDate);
      return true; // If no exception occurs, permission is granted
    } catch (e) {
      return false; // Exception indicates permission is not granted
    }
  }

  // Redirect user to Usage Access settings
  Future<void> _redirectToUsageAccessSettings() async {
    try {
      await openAppSettings(); // Use permission_handler to open settings
    } catch (e) {
      if (kDebugMode) {
        print('Error redirecting to Usage Access settings: $e');
      }
    }
  }

  // Step Counting Logic
  Future<void> _fetchStepCount() async {
    Pedometer.stepCountStream.listen((event) {
      setState(() {
        _stepCount = event.steps.toString();
      });
    }).onError((error) {
      if (kDebugMode) {
        print("Pedometer Error: $error");
      }
      setState(() {
        _stepCount = 'Error';
      });
    });
  }

// Screen Time Logic
  Future<void> _fetchScreenTime() async {
    if (Platform.isAndroid) {
      try {
        DateTime startDate = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
        DateTime endDate = DateTime.now();

        List<AppUsageInfo> usageInfoList =
            await AppUsage().getAppUsage(startDate, endDate);

        int totalMinutes = usageInfoList.fold(
          0,
          (sum, app) => sum + app.usage.inMinutes,
        );

        int hours = totalMinutes ~/ 60;
        int minutes = totalMinutes % 60;

        String timeString;
        if (hours > 0) {
          timeString = '$hours hours and $minutes minutes';
        } else {
          timeString = '$minutes minutes';
        }

        setState(() {
          _screenTime = timeString;
        });
      } catch (e) {
        setState(() {
          _screenTime =
              'Error fetching screen time. Please grant Usage Access in settings.';
        });
      }
    } else {
      setState(() {
        _screenTime = 'Not available on iOS'; // iOS message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Widget')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Step Count: $_stepCount steps',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Screen Time: $_screenTime',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
