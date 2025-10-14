// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

import 'package:screen_lock_detector/screen_lock_detector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    ScreenLockDetector.statusStream.listen((status) {
      // ignore: avoid_print
      print("==> Screen status: $status");
      if (status == ScreenStatus.locked) {
        // Do something here when screen is locked
      } else if (status == ScreenStatus.unlocked) {
        // Do something here when screen is unlocked
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Screen Lock Detector')),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final status = await ScreenLockDetector.checkScreenStatus();
                  // ignore: avoid_print
                  print("==> Screen status: $status");
                },
                child: const Text('Get Screen Status'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
