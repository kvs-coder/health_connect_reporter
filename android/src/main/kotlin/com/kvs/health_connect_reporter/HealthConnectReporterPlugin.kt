package com.kvs.health_connect_reporter

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.cancel

/**
 * The Android side of the plugin: Health Connect through HealthConnectReporter.
 *
 * One [ReporterHealthConnect] serves the method channel. Calls run in a plugin-owned scope on the main thread,
 * which is cancelled when the engine detaches. The permission screen runs on the attached activity through
 * [PermissionLauncher], so apps keep a plain `FlutterActivity`.
 */
class HealthConnectReporterPlugin :
    FlutterPlugin,
    ActivityAware {
    private var methodChannel: MethodChannel? = null
    private var scope: CoroutineScope? = null
    private var binding: ActivityPluginBinding? = null
    private val launcher = PermissionLauncher { activity }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val scope = MainScope().also { scope = it }
        val health = ReporterHealthConnect(binding.applicationContext, { activity }, launcher)
        val dispatcher = HealthConnectDispatcher(health, scope)
        methodChannel =
            MethodChannel(binding.binaryMessenger, METHOD_CHANNEL).apply { setMethodCallHandler(dispatcher) }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        scope?.cancel()
        scope = null
    }

    private val activity: Activity?
        get() = binding?.activity

    override fun onAttachedToActivity(binding: ActivityPluginBinding) = attach(binding)

    override fun onDetachedFromActivityForConfigChanges() = detach()

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) = attach(binding)

    override fun onDetachedFromActivity() = detach()

    private fun attach(binding: ActivityPluginBinding) {
        this.binding = binding.apply { addActivityResultListener(launcher) }
    }

    private fun detach() {
        binding?.removeActivityResultListener(launcher)
        binding = null
    }
}
