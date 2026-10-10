package com.kvs.health_connect_reporter

import com.kvs.healthconnectreporter.HealthConnectException
import com.kvs.healthconnectreporter.model.Permission
import com.kvs.healthconnectreporter.model.type.Feature
import kotlinx.serialization.KSerializer
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonArray
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonNull
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive

// Readers of the arguments Dart sends; a missing or mistyped argument throws HealthConnectException.InvalidValue

private fun missing(key: String): Nothing = throw HealthConnectException.InvalidValue("Missing argument: $key")

internal fun Map<String, Any?>.string(key: String): String = this[key] as? String ?: missing(key)

internal fun Map<String, Any?>.map(key: String): Map<String, Any?> = this[key].asMap ?: missing(key)

internal fun Map<String, Any?>.maps(key: String): List<Map<String, Any?>> =
    (this[key] as? List<*>)?.map { it.asMap ?: missing(key) } ?: missing(key)

/** A map whose keys are all strings, as Dart sends a model's `map`; null for anything else */
@Suppress("UNCHECKED_CAST")
private val Any?.asMap: Map<String, Any?>?
    get() = (this as? Map<*, *>)?.takeIf { map -> map.keys.all { it is String } } as? Map<String, Any?>

internal fun Map<String, Any?>.feature(): Feature =
    string("feature").let { name ->
        Feature.entries.firstOrNull { it.name == name } ?: throw HealthConnectException.InvalidValue(
            "Invalid feature: $name",
        )
    }

internal fun Map<String, Any?>.permissions(): Set<Permission> =
    maps("permissions").mapTo(mutableSetOf()) { decode(Permission.serializer(), it) }

private val json = Json { ignoreUnknownKeys = true }

/** Decodes a model's `map` that is no library **Payload**, e.g. a permission; Dart's nulls mean absent */
internal fun <T> decode(
    serializer: KSerializer<T>,
    map: Map<String, Any?>,
): T =
    try {
        json.decodeFromJsonElement(serializer, map.element)
    } catch (exception: IllegalArgumentException) {
        // kotlinx.serialization's SerializationException is an IllegalArgumentException
        throw HealthConnectException.InvalidValue("Invalid map: $map", exception)
    }

private val Any?.element: JsonElement
    get() =
        when (this) {
            null -> JsonNull
            is Map<*, *> -> jsonObject
            is List<*> -> JsonArray(map { it.element })
            is Boolean -> JsonPrimitive(this)
            is Number -> JsonPrimitive(this)
            is String -> JsonPrimitive(this)
            else -> throw HealthConnectException.InvalidValue("Invalid value: $this")
        }

/** Dart's nulls mean absent, so their keys are left out */
private val Map<*, *>.jsonObject: JsonObject
    get() = JsonObject(entries.filter { it.value != null }.associate { it.key.toString() to it.value.element })
