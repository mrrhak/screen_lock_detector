import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'screen_lock_detector_platform_interface.dart';
import 'common/screen_status.dart';

/// An implementation of [ScreenLockDetectorPlatform] that uses method channels.
class MethodChannelScreenLockDetector extends ScreenLockDetectorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('screen_lock_detector_method');

  @visibleForTesting
  final eventChannel = const EventChannel('screen_lock_detector_event');

  @override
  Stream<ScreenStatus> get statusStream {
    return eventChannel.receiveBroadcastStream().map(
      (e) => switch (e.toString()) {
        "LOCKED" => ScreenStatus.locked,
        "UNLOCKED" => ScreenStatus.unlocked,
        _ => ScreenStatus.unknown,
      },
    );
  }

  @override
  Future<bool> checkIsLock() async {
    try {
      return (await methodChannel.invokeMethod<bool>('checkIsLock')) ?? false;
    } catch (e) {
      return false;
    }
  }
}
