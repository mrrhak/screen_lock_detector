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
      print("==> Screen status: $status");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  bool isLock = await ScreenLockDetector.checkIsLock();
                  print("==> isLock: $isLock");
                },
                child: const Text('Check is lock'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
