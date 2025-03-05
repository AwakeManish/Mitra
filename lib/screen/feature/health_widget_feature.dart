import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_usage/app_usage.dart'; // Import app_usage package
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
    _fetchStepCount();
    _fetchScreenTime();
  }

  // Step Counting Logic
  Future<void> _fetchStepCount() async {
    if (Platform.isAndroid) {
      final status = await Permission.activityRecognition.status;
      if (status != PermissionStatus.granted) {
        final newStatus = await Permission.activityRecognition.request();
        if (newStatus == PermissionStatus.granted) {
          _startStepCountListener();
        } else {
          setState(() {
            _stepCount = 'Permission Denied';
          });
          if (kDebugMode) {
            print('Activity Recognition permission denied');
          }
        }
      } else {
        _startStepCountListener();
      }
    } else {
      _startStepCountListener();
    }
  }

  void _startStepCountListener() {
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
        // Get app usage data for the past day
        DateTime startDate = DateTime.now().subtract(const Duration(days: 1));
        DateTime endDate = DateTime.now();

        List<AppUsageInfo> usageInfoList =
            await AppUsage().getAppUsage(startDate, endDate);

        int totalMinutes = usageInfoList.fold(
          0,
          (sum, app) => sum + app.usage.inMinutes,
        );

        setState(() {
          _screenTime =
              '${(totalMinutes / 60).toStringAsFixed(1)} hours'; // Display hours using string interpolation
        });
      } catch (e) {
        if (kDebugMode) {
          print("App Usage Error: $e");
        }
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
            ElevatedButton(
              onPressed: () async {
                // Open settings to grant usage access
                await openAppSettings(); // Use permission_handler to open settings
                // After returning from settings, refresh screen time
                await _fetchScreenTime();
              },
              child: const Text('Grant Usage Access'),
            ),
          ],
        ),
      ),
    );
  }
}
