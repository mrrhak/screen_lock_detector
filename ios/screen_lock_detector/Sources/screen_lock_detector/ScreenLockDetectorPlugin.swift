import Flutter
import UIKit

public class ScreenLockDetectorPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?
  private var screenStatus: String = "UNKNOWN"

  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(
      name: "screen_lock_detector_method", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(
      name: "screen_lock_detector_event", binaryMessenger: registrar.messenger())
    let instance = ScreenLockDetectorPlugin()
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    eventChannel.setStreamHandler(instance)

    NotificationCenter.default.addObserver(
      instance,
      selector: #selector(deviceWillLock),
      name: UIApplication.protectedDataWillBecomeUnavailableNotification,
      object: nil
    )

    NotificationCenter.default.addObserver(
      instance,
      selector: #selector(deviceDidUnlock),
      name: UIApplication.protectedDataDidBecomeAvailableNotification,
      object: nil
    )
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "checkScreenStatus":
      return result(screenStatus)
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

  @objc func deviceWillLock() {
    let status: String = "LOCKED"
    guard self.screenStatus != status else { return }
    self.screenStatus = status
    self.eventSink?(status)
  }

  @objc func deviceDidUnlock() {
    let status: String = "UNLOCKED"
    guard self.screenStatus != status else { return }
    self.screenStatus = status
    self.eventSink?(status)
  }
}
