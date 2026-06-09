# Changelog

## 2.0.0
- Updates minimum supported SDK version to Flutter 3.44 / Dart 3.12
- Migrates Android to Flutter 3.44 built-in Kotlin support
- Adds `FlutterFramework` dependency and improves tests on iOS
- Fix iOS: `NotificationCenter` observers are now removed in `deinit` to prevent crash and duplicate events on engine detach / add-to-app
- Fix iOS: `checkScreenStatus()` initial value changed from `UNLOCKED` to `UNKNOWN` so the first real lock/unlock notification is never suppressed
- Fix Android: `BroadcastReceiver` is now guarded against double-registration when the stream is resubscribed
- Fix Android: `onCancel` now safely handles unregistering a never-registered receiver
- Fix Android: null `appContext` in `onListen` now surfaces an error instead of silently dropping receiver registration
- **BREAKING**: `ScreenStatus.name` renamed to `ScreenStatus.value` to stop shadowing Dart's built-in `Enum.name`

## 1.0.0
- Detect when the screen is locked
- Detect when the screen is unlocked
- Supports both event streams and manual status checks
- Works on Android and iOS
