import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'screen_lock_detector_platform_interface.dart';
import 'common/screen_status.dart';

/// An implementation of [ScreenLockDetectorPlatform] that uses method channels.
class MethodChannelScreenLockDetector extends ScreenLockDetectorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('screen_lock_detector_method');

  /// The event channel used to receive screen lock status updates from the native platform.
  @visibleForTesting
  final eventChannel = const EventChannel('screen_lock_detector_event');

  @override
  Stream<ScreenStatus> get statusStream {
    return eventChannel
        .receiveBroadcastStream()
        .map((e) => ScreenStatus.fromValue(e?.toString()));
  }

  @override
  Future<ScreenStatus> checkScreenStatus() async {
    final res = await methodChannel.invokeMethod<String>('checkScreenStatus');
    return ScreenStatus.fromValue(res);
  }
}
