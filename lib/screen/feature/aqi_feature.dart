import 'package:flutter/material.dart';
import '../../apis/apis.dart';

class AQIFeature extends StatefulWidget {
  const AQIFeature({super.key});

  @override
  AQIFeatureState createState() => AQIFeatureState();
}

class AQIFeatureState extends State<AQIFeature> {
  String? aqiDataMessage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getAQIData(37.7749, -122.4194); // Example coordinates
  }

  // Function to get AQI data
  void getAQIData(double lat, double lon) async {
    setState(() {
      isLoading = true;
      aqiDataMessage = null;
    });

    final aqiData = await APIs.fetchAQI(lat, lon);

    setState(() {
      isLoading = false;
      if (aqiData != null && aqiData.containsKey('error')) {
        aqiDataMessage = 'Error: ${aqiData['error']}';
      } else {
        final aqiIndex = aqiData?['list']?[0]?['main']?['aqi'];
        aqiDataMessage = 'AQI: $aqiIndex';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AQI Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                getAQIData(37.7749,
                    -122.4194); // Replace with actual location if needed
              },
              child: const Text('Get AQI'),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator() // Show loading indicator when fetching data
                : Text(
                    aqiDataMessage ?? 'Press the button to get AQI data',
                    style: const TextStyle(fontSize: 18),
                  ),
          ],
        ),
      ),
    );
  }
}
