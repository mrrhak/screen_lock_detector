import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'screen_lock_detector_method_channel.dart';
import 'common/screen_status.dart';

/// The interface that implementations of screen_lock_detector must implement.
abstract class ScreenLockDetectorPlatform extends PlatformInterface {
  /// Constructs a ScreenLockDetectorPlatform.
  ScreenLockDetectorPlatform() : super(token: _token);

  static final Object _token = Object();

  static ScreenLockDetectorPlatform _instance =
      MethodChannelScreenLockDetector();

  /// The default instance of [ScreenLockDetectorPlatform] to use.
  ///
  /// Defaults to [MethodChannelScreenLockDetector].
  static ScreenLockDetectorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ScreenLockDetectorPlatform] when
  /// they register themselves.
  static set instance(ScreenLockDetectorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// A broadcast stream of screen lock status changes.
  Stream<ScreenStatus> get statusStream {
    throw UnimplementedError('statusStream has not been implemented.');
  }

  /// Checks the current screen lock status.
  Future<ScreenStatus> checkScreenStatus() {
    throw UnimplementedError('checkScreenStatus has not been implemented.');
  }
}
