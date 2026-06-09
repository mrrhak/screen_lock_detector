import Flutter
import UIKit
import XCTest
@testable import screen_lock_detector

class RunnerTests: XCTestCase {

  func testCheckScreenStatus_returnsUnlockedByDefault() {
    let plugin = ScreenLockDetectorPlugin()
    let call = FlutterMethodCall(methodName: "checkScreenStatus", arguments: nil)
    var result: Any?

    plugin.handle(call) { value in result = value }

    XCTAssertEqual(result as? String, "UNLOCKED")
  }

  func testUnknownMethod_returnsNotImplemented() {
    let plugin = ScreenLockDetectorPlugin()
    let call = FlutterMethodCall(methodName: "unknownMethod", arguments: nil)
    var result: Any?

    plugin.handle(call) { value in result = value }

    XCTAssertTrue((result as AnyObject) === (FlutterMethodNotImplemented as AnyObject))
  }

  func testDeviceWillLock_setsStatusToLocked() {
    let plugin = ScreenLockDetectorPlugin()

    plugin.deviceWillLock()

    let call = FlutterMethodCall(methodName: "checkScreenStatus", arguments: nil)
    var result: Any?
    plugin.handle(call) { value in result = value }

    XCTAssertEqual(result as? String, "LOCKED")
  }

  func testDeviceDidUnlock_setsStatusBackToUnlocked() {
    let plugin = ScreenLockDetectorPlugin()
    plugin.deviceWillLock()

    plugin.deviceDidUnlock()

    let call = FlutterMethodCall(methodName: "checkScreenStatus", arguments: nil)
    var result: Any?
    plugin.handle(call) { value in result = value }

    XCTAssertEqual(result as? String, "UNLOCKED")
  }

  func testDeviceWillLock_doesNotFireTwice() {
    let plugin = ScreenLockDetectorPlugin()
    var sinkCallCount = 0
    plugin.onListen(withArguments: nil) { _ in sinkCallCount += 1 }

    plugin.deviceWillLock()
    plugin.deviceWillLock()

    XCTAssertEqual(sinkCallCount, 1)
  }

  func testDeviceDidUnlock_doesNotFireTwiceWhenAlreadyUnlocked() {
    let plugin = ScreenLockDetectorPlugin()
    var sinkCallCount = 0
    plugin.onListen(withArguments: nil) { _ in sinkCallCount += 1 }

    plugin.deviceDidUnlock()
    plugin.deviceDidUnlock()

    XCTAssertEqual(sinkCallCount, 0)
  }

}
