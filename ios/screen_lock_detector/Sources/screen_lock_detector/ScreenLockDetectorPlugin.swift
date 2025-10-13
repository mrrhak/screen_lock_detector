import Flutter
import UIKit

public class ScreenLockDetectorPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(
      name: "screen_lock_detector_method", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(
      name: "screen_lock_detector_event", binaryMessenger: registrar.messenger())
    let instance = ScreenLockDetectorPlugin()
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    eventChannel.setStreamHandler(instance)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(deviceWillLock),
      name: UIApplication.protectedDataWillBecomeUnavailableNotification,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(deviceDidUnlock),
      name: UIApplication.protectedDataDidBecomeAvailableNotification,
      object: nil
    )
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "checkIsLock":
      return result(_checkIsScreenLocked())
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
    -> FlutterError?
  {
    self.eventSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.eventSink = nil
    return nil
  }

  private func _checkIsScreenLocked() -> Bool {
    // When the device is locked, the system restricts access to “protected data” (like Keychain or sensitive files
    // So isProtectedDataAvailable == false means device is locked.
    let isProtectedDataAvailable = UIApplication.shared.isProtectedDataAvailable
    return !isProtectedDataAvailable
  }

  @objc func deviceWillLock() {
    self.eventSink?("LOCKED")
  }

  @objc func deviceDidUnlock() {
    self.eventSink?("UNLOCKED")
  }
}
