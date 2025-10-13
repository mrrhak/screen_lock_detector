import 'src/screen_lock_detector_platform_interface.dart';
import 'src/common/screen_status.dart';

class ScreenLockDetector {
  static Stream<ScreenStatus> get statusStream {
    return ScreenLockDetectorPlatform.instance.statusStream;
  }

  static Future<bool> checkIsLock() {
    return ScreenLockDetectorPlatform.instance.checkIsLock();
  }
}
