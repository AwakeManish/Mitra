import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  String? firebaseCity1;
  int? firebaseAQI1;

  // Function to fetch data from Firebase for city1
  Future<void> fetchCity1DataFromFirebase() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('cities')
          .doc('city1')
          .get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        firebaseCity1 = data['city_name'];
        firebaseAQI1 = data['aqi_value'];
      } else {
        setState(() {
          aqiDataMessage = 'No data found in Firebase for city1.';
        });
      }
    } catch (e) {
      setState(() {
        aqiDataMessage = 'Error fetching data from Firebase: $e';
      });
    }
  }

  // Function to get AQI data and compare
  void getAQIData(String city2) async {
    setState(() {
      isLoading = true;
      aqiDataMessage = null;
    });

    // Fetch AQI data from API for city2
    final aqiData = await APIs.fetchAQI(city2);

    // Fetch data from Firebase for city1
    await fetchCity1DataFromFirebase();

    setState(() {
      isLoading = false;
      if (aqiData.containsKey('error')) {
        aqiDataMessage = 'Error: ${aqiData['error']}';
      } else if (aqiData['aqi'] != null &&
          aqiData['aqi'] is int &&
          firebaseAQI1 != null) {
        final aqi2 = aqiData['aqi'];
        final aqi1 = firebaseAQI1!;

        if (aqi2 > aqi1) {
          aqiDataMessage =
              'AQI in $firebaseCity1 ($aqi1) is less than the AQI in $city2 ($aqi2). It is better to stay in $firebaseCity1.';
        } else if (aqi1 == aqi2) {
          aqiDataMessage =
              'Both $firebaseCity1 and $city2 have the same AQI of $aqi1.';
        } else {
          aqiDataMessage =
              'AQI in $city2 ($aqi2) is less than in $firebaseCity1 ($aqi1). It is better to shift to $city2.';
        }
      } else {
        aqiDataMessage = 'AQI data not available.';
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
        title: const Text('AQI Comparator'),
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
              child: const Text('Compare AQI'),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator()
            else if (aqiDataMessage != null)
              Text(
                aqiDataMessage!,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
