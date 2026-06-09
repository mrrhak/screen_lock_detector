package com.mrrhak.screen_lock_detector

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.mockito.Mockito
import kotlin.test.Test

internal class ScreenLockDetectorPluginTest {
    @Test
    fun onMethodCall_checkScreenStatus_returnsUnknownWhenNotAttached() {
        val plugin = ScreenLockDetectorPlugin()

        val call = MethodCall("checkScreenStatus", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).success("UNKNOWN")
    }

    @Test
    fun onMethodCall_unknownMethod_returnsNotImplemented() {
        val plugin = ScreenLockDetectorPlugin()

        val call = MethodCall("unknownMethod", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).notImplemented()
    }
}
