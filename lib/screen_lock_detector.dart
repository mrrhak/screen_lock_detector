import 'src/screen_lock_detector_platform_interface.dart';
import 'src/common/screen_status.dart';

export 'src/common/screen_status.dart';

/// The main class for interacting with the screen lock detector functionality.
class ScreenLockDetector {
  /// A broadcast stream of screen lock status changes.
  static Stream<ScreenStatus> get statusStream {
    return ScreenLockDetectorPlatform.instance.statusStream;
  }

  /// Checks the current screen lock status.
  static Future<ScreenStatus> checkScreenStatus() {
    return ScreenLockDetectorPlatform.instance.checkScreenStatus();
  }
}
