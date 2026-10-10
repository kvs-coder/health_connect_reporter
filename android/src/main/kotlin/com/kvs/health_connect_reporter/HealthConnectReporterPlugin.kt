package com.kvs.health_connect_reporter

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.cancel

/**
 * The Android side of the plugin: Health Connect through HealthConnectReporter.
 *
 * One [ReporterHealthConnect] serves the method channel. Calls run in a plugin-owned scope on the main thread,
 * which is cancelled when the engine detaches.
 */
class HealthConnectReporterPlugin : FlutterPlugin {
    private var methodChannel: MethodChannel? = null
    private var scope: CoroutineScope? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val scope = MainScope().also { scope = it }
        val dispatcher = HealthConnectDispatcher(ReporterHealthConnect(binding.applicationContext), scope)
        methodChannel =
            MethodChannel(binding.binaryMessenger, METHOD_CHANNEL).apply { setMethodCallHandler(dispatcher) }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        scope?.cancel()
        scope = null
    }
}
