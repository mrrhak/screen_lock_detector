package com.mrrhak.screen_lock_detector

import android.app.KeyguardManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.PowerManager

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.EventChannel

/** ScreenLockDetectorPlugin */
class ScreenLockDetectorPlugin :
    FlutterPlugin,
    MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
    private var appContext: Context? = null
    private var isReceiverRegistered = false

    private val broadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            when (intent?.action) {
                Intent.ACTION_SCREEN_OFF, Intent.ACTION_USER_PRESENT -> {
                    eventSink?.success(_checkScreenStatus())
                }
            }
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "screen_lock_detector_method")
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "screen_lock_detector_event")
        appContext = flutterPluginBinding.applicationContext
        
        methodChannel.setMethodCallHandler(this)
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
                val ctx = appContext
                if (ctx == null) {
                    events?.error("UNAVAILABLE", "Plugin not attached to an engine", null)
                    return
                }
                if (!isReceiverRegistered) {
                    val filter = IntentFilter().apply {
                        addAction(Intent.ACTION_USER_PRESENT)
                        addAction(Intent.ACTION_SCREEN_OFF)
                    }
                    ctx.registerReceiver(broadcastReceiver, filter)
                    isReceiverRegistered = true
                }
            }

            override fun onCancel(arguments: Any?) {
                try {
                    appContext?.unregisterReceiver(broadcastReceiver)
                } catch (_: IllegalArgumentException) {
                    // receiver was not registered
                }
                isReceiverRegistered = false
                eventSink = null
            }
        })
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        if (call.method == "checkScreenStatus") {
            val status = _checkScreenStatus();
            result.success(status)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        if (isReceiverRegistered) {
            try {
                appContext?.unregisterReceiver(broadcastReceiver)
            } catch (_: IllegalArgumentException) {}
            isReceiverRegistered = false
        }
        eventSink = null
        appContext = null
    }

    private fun _checkScreenStatus(): String {
        val context = appContext ?: return "UNKNOWN"

        // Keyguard Manager only work on real device
        val keyguardManager = context.getSystemService(Context.KEYGUARD_SERVICE) as? KeyguardManager
        if (keyguardManager?.isKeyguardLocked == true) return "LOCKED"

        // If no passcode is set, isKeyguardLocked returns false even when the screen is off,
        // so also check display interactivity via PowerManager
        val powerManager = context.getSystemService(Context.POWER_SERVICE) as? PowerManager
        if (!(powerManager?.isInteractive ?: true)) return "LOCKED"
        return "UNLOCKED"
    }
}
