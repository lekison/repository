import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:package_1/accountregistration.dart';
import 'package:package_1/homepage.dart';

void main() async {
  runApp(const MyAppy ());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error initializing Firebase'));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return const LoginPage();
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}


class SpeedTestWidget extends StatefulWidget {
  const SpeedTestWidget({super.key});

  @override
  _SpeedTestWidgetState createState() => _SpeedTestWidgetState();
}

class _SpeedTestWidgetState extends State<SpeedTestWidget> {
  double downloadSpeed = 0;
  double uploadSpeed = 0;
  bool isTesting = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Download Speed: ${downloadSpeed.toStringAsFixed(2)} Mbps'),
        Text('Upload Speed: ${uploadSpeed.toStringAsFixed(2)} Mbps'),
        ElevatedButton(
          onPressed: isTesting ? null : startSpeedTest,
          child: Text(isTesting ? 'Testing...' : 'Start Speed Test'),
        ),
      ],
    );
  }

  Future<void> startSpeedTest() async {
    setState(() {
      isTesting = true;
      downloadSpeed = 0;
      uploadSpeed = 0;
    });

    // Test download speed
    await testDownloadSpeed();

    // Test upload speed
    await testUploadSpeed();

    setState(() {
      isTesting = false;
    });
  }

  Future<void> testDownloadSpeed() async {
    const testUrl = 'https://fast.com/';
    final stopwatch = Stopwatch()..start();
    final response = await http.get(Uri.parse(testUrl));
    stopwatch.stop();

    if (response.statusCode == 200) {
      final bits = response.bodyBytes.length * 8;
      final durationInSeconds = stopwatch.elapsedMilliseconds / 1000;
      final speedBps = bits / durationInSeconds;
      final speedMbps = speedBps / 1000000;

      setState(() {
        downloadSpeed = speedMbps;
      });
    }
  }

  Future<void> testUploadSpeed() async {
    const testUrl = 'https://httpbin.org/post';
    final data = List.generate(1000000, (index) => Random().nextInt(256));
    final stopwatch = Stopwatch()..start();
    final response = await http.post(Uri.parse(testUrl), body: data);
    stopwatch.stop();

    if (response.statusCode == 200) {
      final bits = data.length * 8;
      final durationInSeconds = stopwatch.elapsedMilliseconds / 1000;
      final speedBps = bits / durationInSeconds;
      final speedMbps = speedBps / 1000000;

      setState(() {
        uploadSpeed = speedMbps;
      });
    }
  }
}