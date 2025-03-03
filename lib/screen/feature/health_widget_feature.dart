import 'package:flutter/material.dart';

class HealthWidgetFeature extends StatelessWidget {
  const HealthWidgetFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Widget')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to Step Counter screen
              },
              child: const Text('Step Counter'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Screen Time Tracker screen
              },
              child: const Text('Screen Time Tracker'),
            ),
          ],
        ),
      ),
    );
  }
}
