import 'package:flutter_test/flutter_test.dart';
import 'package:screen_lock_detector/screen_lock_detector.dart';
import 'package:screen_lock_detector/src/screen_lock_detector_platform_interface.dart';
import 'package:screen_lock_detector/src/screen_lock_detector_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:screen_lock_detector/src/common/screen_status.dart';

class MockScreenLockDetectorPlatform
    with MockPlatformInterfaceMixin
    implements ScreenLockDetectorPlatform {
  @override
  Stream<ScreenStatus> get statusStream => Stream.value(ScreenStatus.locked);

  @override
  Future<bool> checkIsLock() async => true;
}

void main() {
  final ScreenLockDetectorPlatform initialPlatform =
      ScreenLockDetectorPlatform.instance;

  test('$MethodChannelScreenLockDetector is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelScreenLockDetector>());
  });

  test('checkIsLock', () async {
    MockScreenLockDetectorPlatform fakePlatform =
        MockScreenLockDetectorPlatform();
    ScreenLockDetectorPlatform.instance = fakePlatform;

    expect(await ScreenLockDetector.checkIsLock(), true);
  });
}
