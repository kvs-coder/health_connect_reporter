package com.kvs.health_connect_reporter

import com.kvs.healthconnectreporter.HealthConnectException
import com.kvs.healthconnectreporter.model.Availability
import com.kvs.healthconnectreporter.model.Payload
import com.kvs.healthconnectreporter.model.Permission
import kotlinx.serialization.builtins.ListSerializer
import kotlinx.serialization.json.Json

// Replies to Dart: the library's JSON

/** **String** the availability's JSON value, e.g. `"available"` */
internal val Availability.json: String
    get() = Json.encodeToString(Availability.serializer(), this)

/** **String** JSON array of the payloads' JSON */
internal val List<Payload>.json: String
    get() = joinToString(",", "[", "]") { it.json }

/** **String** JSON array of the permissions, e.g. `[{"type":"data","healthType":"STEPS","access":"READ"}]` */
internal val Set<Permission>.json: String
    get() = Json.encodeToString(ListSerializer(Permission.serializer()), toList())

/**
 * **String** the error's kind for `PlatformException.details`: `NotAuthorized`, `InvalidType`, `InvalidValue`,
 * `NotAvailable`, `AnchorExpired` or `Platform`
 */
internal val Throwable.details: String
    get() =
        when (this) {
            is HealthConnectException.NotAuthorized -> "NotAuthorized"
            is HealthConnectException.InvalidType -> "InvalidType"
            is HealthConnectException.InvalidValue -> "InvalidValue"
            is HealthConnectException.NotAvailable -> "NotAvailable"
            is HealthConnectException.AnchorExpired -> "AnchorExpired"
            is HealthConnectException.Platform -> "Platform"
            else -> javaClass.simpleName
        }

internal val Throwable.description: String
    get() = message ?: toString()
