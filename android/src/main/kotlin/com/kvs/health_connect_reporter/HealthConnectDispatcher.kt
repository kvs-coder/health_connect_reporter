package com.kvs.health_connect_reporter

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch

/** The method channel of every [Method] */
const val METHOD_CHANNEL = "health_connect_reporter_method_channel"

/** Dart methods of `HealthConnectReporter`, named like them */
@Suppress("EnumEntryName", "ktlint:standard:enum-entry-name-case")
enum class Method {
    availability,
}

/**
 * Runs the method calls of `HealthConnectReporter` in [scope] and replies on its thread, the platform thread.
 *
 * Results are the library's JSON; every failure replies a `PlatformException` whose code is the method name,
 * message the error's message and details its kind (see [details]).
 */
class HealthConnectDispatcher(
    private val health: HealthConnect,
    private val scope: CoroutineScope,
) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        val method = Method.entries.firstOrNull { it.name == call.method } ?: return result.notImplemented()
        scope.launch {
            try {
                result.success(reply(method))
            } catch (exception: CancellationException) {
                throw exception
            } catch (exception: Exception) {
                result.error(method.name, exception.description, exception.details)
            }
        }
    }

    private fun reply(method: Method): Any? =
        when (method) {
            Method.availability -> health.availability().json
        }
}
