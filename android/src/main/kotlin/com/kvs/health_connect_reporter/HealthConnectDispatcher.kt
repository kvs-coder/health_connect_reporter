package com.kvs.health_connect_reporter

import com.kvs.healthconnectreporter.HealthConnectException
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import java.util.UUID
import kotlin.time.Duration.Companion.milliseconds
import kotlin.time.Duration.Companion.minutes

/** The method channel of every [Method] */
const val METHOD_CHANNEL = "health_connect_reporter_method_channel"

/** Prefix of the event channel of every observe subscription */
const val OBSERVE_EVENT_CHANNEL = "health_connect_reporter_event_channel_observe_"

/** Dart methods of `HealthConnectReporter`, named like them */
@Suppress("EnumEntryName", "ktlint:standard:enum-entry-name-case")
enum class Method {
    availability,
    requestPermissions,
    grantedPermissions,
    revokeAllPermissions,
    isFeatureAvailable,
    openSettings,
    openInstall,
    read,
    readPage,
    readById,
    aggregate,
    aggregateGroups,
    insert,
    update,
    delete,
    deleteByIds,
    deleteByRange,
    anchor,
    changes,
    observe,
}

/**
 * Runs the method calls of `HealthConnectReporter` in [scope] and replies on its thread, the platform thread.
 *
 * Results are the library's JSON (lists as JSON arrays) or bools; every failure replies a `PlatformException` whose
 * code is the method name, message the error's message and details its kind (see [details]).
 *
 * @param open registers an event channel of an observe subscription
 * @param close unregisters it once Dart cancels the subscription
 */
class HealthConnectDispatcher(
    private val health: HealthConnect,
    private val scope: CoroutineScope,
    private val open: (name: String, handler: EventChannel.StreamHandler) -> Unit,
    private val close: (name: String) -> Unit,
) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        val method = Method.entries.firstOrNull { it.name == call.method } ?: return result.notImplemented()
        scope.launch {
            try {
                result.success(reply(method, call.argumentMap))
            } catch (exception: CancellationException) {
                throw exception
            } catch (exception: Exception) {
                result.error(method.name, exception.description, exception.details)
            }
        }
    }

    private val MethodCall.argumentMap: Map<String, Any?>
        get() =
            when (val arguments = arguments) {
                null -> emptyMap()
                is Map<*, *> -> arguments.entries.associate { (key, value) -> key.toString() to value }
                else -> throw HealthConnectException.InvalidValue("Invalid arguments: $arguments")
            }

    @Suppress("CyclomaticComplexMethod")
    private suspend fun reply(
        method: Method,
        arguments: Map<String, Any?>,
    ): Any? =
        when (method) {
            Method.availability -> {
                health.availability().json
            }

            Method.requestPermissions -> {
                health.requestPermissions(arguments.permissions()).json
            }

            Method.grantedPermissions -> {
                health.grantedPermissions().json
            }

            Method.revokeAllPermissions -> {
                health.revokeAllPermissions().let { true }
            }

            Method.isFeatureAvailable -> {
                health.isFeatureAvailable(arguments.feature())
            }

            Method.openSettings -> {
                health.openSettings().let { true }
            }

            Method.openInstall -> {
                health.openInstall().let { true }
            }

            Method.read -> {
                health
                    .read(
                        arguments.healthType(),
                        arguments.range(),
                        arguments.ordering(),
                        arguments.optionalInt("limit"),
                        arguments.origins(),
                    ).json
            }

            Method.readPage -> {
                health
                    .readPage(
                        arguments.healthType(),
                        arguments.range(),
                        arguments.optionalInt("pageSize") ?: DEFAULT_PAGE_SIZE,
                        arguments.optionalString("pageToken"),
                        arguments.ordering(),
                        arguments.origins(),
                    ).json
            }

            Method.readById -> {
                health.readById(arguments.healthType(), arguments.string("id")).json
            }

            Method.aggregate -> {
                health.aggregate(arguments.aggregation(), arguments.range(), arguments.origins()).json
            }

            Method.aggregateGroups -> {
                health
                    .aggregateGroups(
                        arguments.aggregations(),
                        arguments.range(),
                        arguments.timeGroup(),
                        arguments.origins(),
                    ).json
            }

            Method.insert -> {
                health.insert(arguments.samples()).json
            }

            Method.update -> {
                health.update(arguments.samples()).let { true }
            }

            Method.delete -> {
                health.delete(arguments.map("sample").sample).let { true }
            }

            Method.deleteByIds -> {
                health
                    .deleteByIds(
                        arguments.healthType(),
                        arguments.optionalStrings("ids"),
                        arguments.optionalStrings("clientRecordIds"),
                    ).let { true }
            }

            Method.deleteByRange -> {
                health.deleteByRange(arguments.healthType(), arguments.range()).let { true }
            }

            Method.anchor -> {
                health.anchor(arguments.healthTypes(), arguments.origins()).json
            }

            Method.changes -> {
                health.changes(arguments.anchor()).json
            }

            Method.observe -> {
                openObserveChannel(arguments)
            }
        }

    /**
     * Checks the arguments of an observe subscription and opens its event channel; Dart listens to it to start
     * polling and cancels it to stop polling and close the channel.
     *
     * @return **String** the event channel's name
     */
    private fun openObserveChannel(arguments: Map<String, Any?>): String {
        val interval = arguments.optionalLong("interval")?.milliseconds ?: 1.minutes
        val changeSets = health.observe(arguments.anchor(), interval)
        val name = OBSERVE_EVENT_CHANNEL + UUID.randomUUID()
        open(name, ObserveStreamHandler(changeSets, scope) { close(name) })
        return name
    }

    private companion object {
        /** HealthConnectReader's default page size */
        const val DEFAULT_PAGE_SIZE = 1000
    }
}
