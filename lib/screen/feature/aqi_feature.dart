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
  final TextEditingController cityController = TextEditingController();

  // Function to get AQI data
  void getAQIData(String city) async {
    setState(() {
      isLoading = true;
      aqiDataMessage = null;
    });

    final aqiData = await APIs.fetchAQI(city);

    setState(() {
      isLoading = false;
      if (aqiData.containsKey('error')) {
        aqiDataMessage = 'Error: ${aqiData['error']}';
      } else if (aqiData['aqi'] != null && aqiData['aqi'] is int) {
        final aqiIndex = aqiData['aqi'];
        aqiDataMessage = 'AQI for $city: $aqiIndex';
      } else {
        aqiDataMessage = 'AQI data not available for $city.';
      }
    });
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
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
          children: [
            TextFormField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: 'Enter City Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final city = cityController.text.trim();
                if (city.isNotEmpty) {
                  getAQIData(city);
                } else {
                  setState(() {
                    aqiDataMessage = 'Please enter a city name.';
                  });
                }
              },
              child: const Text('Get AQI'),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator()
            else if (aqiDataMessage != null)
              Text(
                aqiDataMessage!,
                style: const TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}
