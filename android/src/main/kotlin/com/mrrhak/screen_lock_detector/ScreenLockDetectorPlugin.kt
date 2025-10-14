package com.mrrhak.screen_lock_detector

import android.content.BroadcastReceiver
import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
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

    private val broadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            when (intent?.action) {
                // Screen turned off (locked or timed out)
                Intent.ACTION_SCREEN_OFF -> {
                    val status = _checkScreenStatus()
                    eventSink?.success(status)
                }

                // User successfully unlocked after lock screen
                Intent.ACTION_USER_PRESENT -> {
                    val status = _checkScreenStatus()
                    eventSink?.success(status)
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
                val filter = IntentFilter().apply {
                    addAction(Intent.ACTION_USER_PRESENT)
                    addAction(Intent.ACTION_SCREEN_OFF)
                }
                appContext!!.registerReceiver(broadcastReceiver, filter)
            }

            override fun onCancel(arguments: Any?) {
                appContext!!.unregisterReceiver(broadcastReceiver)
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
        appContext = null
    }

    private fun _checkScreenStatus(): String {
        val context = appContext ?: return "UNKNOWN"

        // Keyguard Manager only work on real device
        val keyguardManager = context.getSystemService(Context.KEYGUARD_SERVICE) as? KeyguardManager
        var isLocked = keyguardManager?.isKeyguardLocked ?: false
        if(isLocked) return "LOCKED"

        // If password is not set in the settings, the isKeyguardLocked returns false,
        // so we need to check if screen on for this case
        val powerManager = context.getSystemService(Context.POWER_SERVICE) as? PowerManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT_WATCH) {
            isLocked = !(powerManager?.isInteractive ?: true)
        } else {
            isLocked = !(powerManager?.isScreenOn ?: true)
        }
        if(isLocked) return "LOCKED"
        return "UNLOCKED"
    }
}
