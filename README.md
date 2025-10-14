<div align="center">
  <h1 align="center" style="font-size: 50px;">🪴 Screen Lock Detector 🪴</h1>
</div>

<div align="center">
<p align="center">
A Flutter plugin that enables your app to detect screen lock and unlock events across Android and iOS platforms.

The plugin provides native event callbacks for both Android and iOS, making it easy to respond to lock screen changes — such as pausing sensitive activities, logging out users, or triggering background operations.
</p>
</div>

<div align="center">
   <!--  Donations -->
  <a href="https://ko-fi.com/mrrhak">
    <img width="300" src="https://user-images.githubusercontent.com/26390946/161375567-9e14cd0e-1675-4896-a576-a449b0bcd293.png">
  </a>
  <div align="center">
    <a href="https://www.buymeacoffee.com/mrrhak">
      <img width="150" alt="buy me a coffee" src="https://user-images.githubusercontent.com/26390946/161375563-69c634fd-89d2-45ac-addd-931b03996b34.png">
    </a>
    <a href="https://ko-fi.com/mrrhak">
      <img width="150" alt="Ko-fi" src="https://user-images.githubusercontent.com/26390946/161375565-e7d64410-bbcf-4a28-896b-7514e106478e.png">
    </a>
  </div>
  <!--  Donations -->
</div>

<div align="center">
  <a href="https://pub.dartlang.org/packages/screen_lock_detector">
    <img src="https://img.shields.io/pub/v/screen_lock_detector?label=Pub&logo=dart"
      alt="Pub Package" />
  </a>
  <a href="https://pub.dev/packages/screen_lock_detector">
    <img src="https://img.shields.io/pub/likes/screen_lock_detector?style=flat&logo=dart&label=Likes" alt="Pub Likes"/>
  </a>
  <a href="https://pub.dartlang.org/packages/screen_lock_detector/score">
    <img src="https://img.shields.io/pub/points/screen_lock_detector?label=Score&logo=dart"
      alt="Pub Score" />
  </a>
  <a href="https://pub.dev/packages/screen_lock_detector">
    <img alt="Pub Monthly Downloads" src="https://img.shields.io/pub/dm/screen_lock_detector?style=flat&color=blue&logo=dart&label=Downloads&link=https%3A%2F%2Fpub.dev%2Fpackages%2Fscreen_lock_detector">
  </a>
  <a href="https://github.com/mrrhak/screen_lock_detector"><img src="https://img.shields.io/github/stars/mrrhak/screen_lock_detector.svg?style=flat&logo=github&colorB=deeppink&label=Stars" alt="Star on Github"></a>
  <a href="https://github.com/mrrhak/screen_lock_detector"><img src="https://img.shields.io/github/forks/mrrhak/screen_lock_detector?color=orange&label=Forks&logo=github" alt="Forks on Github"></a>
  <a href="https://github.com/mrrhak/screen_lock_detector/graphs/contributors">
    <img src="https://img.shields.io/github/contributors/mrrhak/screen_lock_detector.svg?style=flat&logo=github&colorB=yellow&label=Contributors"
      alt="Contributors" />
  </a>
  <a href="https://github.com/mrrhak/screen_lock_detector/actions?query=workflow%3A">
    <img src="https://github.com/mrrhak/screen_lock_detector/actions/workflows/format-analyze-test.yml/badge.svg"
      alt="Build Status" />
  </a>
  <a href="https://github.com/mrrhak/screen_lock_detector">
    <img src="https://img.shields.io/github/languages/code-size/mrrhak/screen_lock_detector?logo=github&color=blue&label=Size"
      alt="Code size" />
  </a>
  <a href="https://pub.dev/packages/screen_lock_detector">
    <img src="https://img.shields.io/badge/Platform-Android%20|%20iOS%20-blue.svg?logo=flutter"
      alt="Platform" />
  </a>
</div>

---

<p align="center">
  <img src="https://raw.githubusercontent.com/mrrhak/screen_lock_detector/master/assets/screen_lock_detector_preview.png" width="500" alt="screen lock detector preview"/>
</p>

## How it's work?
For iOS, this plugin just listen to `UIApplication` notification center API:
- `protectedDataWillBecomeUnavailableNotification` to detect is **locked**
- `protectedDataDidBecomeAvailableNotification` to detect is **unlocked**

For Android, this plugin uses `KeyguardManager` and `PowerManager` API to check if device is secured lock or display is off combine with listener on `Intent` actions:
- `ACTION_SCREEN_OFF` to detect is **locked**
- `ACTION_USER_PRESENT` to detect is **unlocked**


## Features
- ✅ Detect when the screen is locked.
- ✅ Detect when the screen is unlocked.
- ✅ Supports both event streams and manual status checks.
- ✅ Works on Android and iOS.

## Usage
### Import Plugin
```dart
import 'package:screen_lock_detector/screen_lock_detector.dart';
```

### Listen to Event Stream
```dart
ScreenLockDetector.statusStream.listen((status) {
    print("Screen status: $status");
    if (status == ScreenStatus.locked) {
    // Do something here when screen is locked
    } else if (status == ScreenStatus.unlocked) {
    // Do something here when screen is unlocked
    }
});
```

### Or Manual Status Check
```dart
final status = await ScreenLockDetector.checkScreenStatus();
print("Screen status: $status");
```

See the [example](https://github.com/mrrhak/screen_lock_detector/tree/master/example) for runnable examples of various usages.

## Bugs or Requests

If you encounter any problems feel free to open an [issue](https://github.com/mrrhak/screen_lock_detector/issues/new?template=bug_report.md). If you feel the library is missing a feature, please raise a [ticket](https://github.com/mrrhak/screen_lock_detector/issues/new?template=feature_request.md) on GitHub and I'll look into it. Pull request are also welcome.

See [Contributing.md](https://github.com/mrrhak/screen_lock_detector/blob/master/CONTRIBUTING.md).

## Support
Don't forget to give it a like 👍 or a star ⭐

## Activities
![Alt](https://repobeats.axiom.co/api/embed/35602a25c897379cbb5233a066c030c0c082b45d.svg "Repobeats analytics image")