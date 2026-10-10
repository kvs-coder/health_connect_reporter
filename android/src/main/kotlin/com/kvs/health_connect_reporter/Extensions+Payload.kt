package com.kvs.health_connect_reporter

import com.kvs.healthconnectreporter.HealthConnectException
import com.kvs.healthconnectreporter.model.Availability
import kotlinx.serialization.json.Json

// Replies to Dart: the library's JSON

/** **String** the availability's JSON value, e.g. `"available"` */
internal val Availability.json: String
    get() = Json.encodeToString(Availability.serializer(), this)

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
