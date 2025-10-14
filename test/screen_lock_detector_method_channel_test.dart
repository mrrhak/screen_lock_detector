import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_lock_detector/src/common/screen_status.dart';
import 'package:screen_lock_detector/src/screen_lock_detector_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelScreenLockDetector platform = MethodChannelScreenLockDetector();
  const MethodChannel channel = MethodChannel('screen_lock_detector_method');
  const EventChannel event = EventChannel('screen_lock_detector_event');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'checkScreenStatus') {
            return "LOCKED";
          }
          return null;
        });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockStreamHandler(event, _MockStreamHandler());
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('checkScreenStatus', () async {
    expect(await platform.checkScreenStatus(), ScreenStatus.locked);
  });

  test('should receive events from mock stream', () async {
    final events = <ScreenStatus>[];
    final subscription = platform.statusStream.listen(events.add);

    // Wait for events
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(events, containsAll([ScreenStatus.locked, ScreenStatus.unlocked]));

    await subscription.cancel();
  });
}

class _MockStreamHandler extends MockStreamHandler {
  final _controller = StreamController<String>();

  _MockStreamHandler() {
    // Simulate native side sending events
    Future.microtask(() async {
      _controller.add('LOCKED');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      _controller.add('UNLOCKED');
    });
  }

  @override
  void onListen(Object? arguments, MockStreamHandlerEventSink events) {
    _controller.stream.listen((event) => events.success(event));
  }

  @override
  void onCancel(Object? arguments) {
    _controller.close();
  }
}
