package com.kvs.health_connect_reporter

import com.kvs.healthconnectreporter.HealthConnectException
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
}

/**
 * Runs the method calls of `HealthConnectReporter` in [scope] and replies on its thread, the platform thread.
 *
 * Results are the library's JSON (lists as JSON arrays) or bools; every failure replies a `PlatformException` whose
 * code is the method name, message the error's message and details its kind (see [details]).
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
        }

    private companion object {
        /** HealthConnectReader's default page size */
        const val DEFAULT_PAGE_SIZE = 1000
    }
}
