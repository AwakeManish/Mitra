import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:app_usage/app_usage.dart';

class HealthWidgetFeature extends StatefulWidget {
  const HealthWidgetFeature({super.key});

  @override
  State<HealthWidgetFeature> createState() => _HealthWidgetFeatureState();
}

class _HealthWidgetFeatureState extends State<HealthWidgetFeature> {
  String _stepCount = '0'; // Step count variable
  String _screenTime = '0'; // Screen time variable

  @override
  void initState() {
    super.initState();
    _fetchStepCount();
    _fetchScreenTime();
  }

  // Fetch step count using Pedometer package
  void _fetchStepCount() {
    Pedometer.stepCountStream.listen((event) {
      setState(() {
        _stepCount = event.steps.toString();
      });
    }).onError((error) {
      setState(() {
        _stepCount = 'Error';
      });
    });
  }

  // Fetch screen time using AppUsage package
  Future<void> _fetchScreenTime() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(const Duration(hours: 24));
      List<AppUsageInfo> usageInfoList =
          await AppUsage().getAppUsage(startDate, endDate);

      int totalMinutes = usageInfoList.fold(
        0,
        (sum, app) => sum + app.usage.inMinutes,
      );

      setState(() {
        _screenTime =
            (totalMinutes / 60).toStringAsFixed(1); // Convert to hours
      });
    } catch (e) {
      setState(() {
        _screenTime = 'Error';
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
              'Screen Time: $_screenTime hours',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
