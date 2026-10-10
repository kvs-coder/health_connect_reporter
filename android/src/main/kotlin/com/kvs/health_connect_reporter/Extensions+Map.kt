package com.kvs.health_connect_reporter

import com.kvs.healthconnectreporter.HealthConnectException
import com.kvs.healthconnectreporter.model.Anchor
import com.kvs.healthconnectreporter.model.DataOrigin
import com.kvs.healthconnectreporter.model.Ordering
import com.kvs.healthconnectreporter.model.Permission
import com.kvs.healthconnectreporter.model.TimeGroup
import com.kvs.healthconnectreporter.model.TimeRange
import com.kvs.healthconnectreporter.model.payload.ActiveCaloriesBurned
import com.kvs.healthconnectreporter.model.payload.BasalBodyTemperature
import com.kvs.healthconnectreporter.model.payload.BasalMetabolicRate
import com.kvs.healthconnectreporter.model.payload.BloodGlucose
import com.kvs.healthconnectreporter.model.payload.BloodPressure
import com.kvs.healthconnectreporter.model.payload.BodyFat
import com.kvs.healthconnectreporter.model.payload.BodyTemperature
import com.kvs.healthconnectreporter.model.payload.BodyWaterMass
import com.kvs.healthconnectreporter.model.payload.BoneMass
import com.kvs.healthconnectreporter.model.payload.CervicalMucus
import com.kvs.healthconnectreporter.model.payload.CyclingPedalingCadence
import com.kvs.healthconnectreporter.model.payload.Distance
import com.kvs.healthconnectreporter.model.payload.ElevationGained
import com.kvs.healthconnectreporter.model.payload.ExerciseSession
import com.kvs.healthconnectreporter.model.payload.FloorsClimbed
import com.kvs.healthconnectreporter.model.payload.HeartRate
import com.kvs.healthconnectreporter.model.payload.HeartRateVariabilityRmssd
import com.kvs.healthconnectreporter.model.payload.Height
import com.kvs.healthconnectreporter.model.payload.Hydration
import com.kvs.healthconnectreporter.model.payload.IntermenstrualBleeding
import com.kvs.healthconnectreporter.model.payload.LeanBodyMass
import com.kvs.healthconnectreporter.model.payload.MenstruationFlow
import com.kvs.healthconnectreporter.model.payload.MenstruationPeriod
import com.kvs.healthconnectreporter.model.payload.MindfulnessSession
import com.kvs.healthconnectreporter.model.payload.Nutrition
import com.kvs.healthconnectreporter.model.payload.OvulationTest
import com.kvs.healthconnectreporter.model.payload.OxygenSaturation
import com.kvs.healthconnectreporter.model.payload.PlannedExerciseSession
import com.kvs.healthconnectreporter.model.payload.Power
import com.kvs.healthconnectreporter.model.payload.RespiratoryRate
import com.kvs.healthconnectreporter.model.payload.RestingHeartRate
import com.kvs.healthconnectreporter.model.payload.SexualActivity
import com.kvs.healthconnectreporter.model.payload.SkinTemperature
import com.kvs.healthconnectreporter.model.payload.SleepSession
import com.kvs.healthconnectreporter.model.payload.Speed
import com.kvs.healthconnectreporter.model.payload.Steps
import com.kvs.healthconnectreporter.model.payload.StepsCadence
import com.kvs.healthconnectreporter.model.payload.TotalCaloriesBurned
import com.kvs.healthconnectreporter.model.payload.Vo2Max
import com.kvs.healthconnectreporter.model.payload.Weight
import com.kvs.healthconnectreporter.model.payload.WheelchairPushes
import com.kvs.healthconnectreporter.model.payload.WritableSample
import com.kvs.healthconnectreporter.model.type.Aggregation
import com.kvs.healthconnectreporter.model.type.Feature
import com.kvs.healthconnectreporter.model.type.HealthType
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

internal fun Map<String, Any?>.optionalString(key: String): String? = this[key] as? String

// Dart ints arrive as Integer or Long, depending on their size
internal fun Map<String, Any?>.optionalInt(key: String): Int? = (this[key] as? Number)?.toInt()

internal fun Map<String, Any?>.optionalLong(key: String): Long? = (this[key] as? Number)?.toLong()

internal fun Map<String, Any?>.strings(key: String): List<String> =
    (this[key] as? List<*>)?.map { it as? String ?: missing(key) } ?: missing(key)

internal fun Map<String, Any?>.optionalStrings(key: String): List<String> =
    if (this[key] == null) emptyList() else strings(key)

internal fun Map<String, Any?>.map(key: String): Map<String, Any?> = this[key].asMap ?: missing(key)

internal fun Map<String, Any?>.maps(key: String): List<Map<String, Any?>> =
    (this[key] as? List<*>)?.map { it.asMap ?: missing(key) } ?: missing(key)

/** A map whose keys are all strings, as Dart sends a model's `map`; null for anything else */
@Suppress("UNCHECKED_CAST")
private val Any?.asMap: Map<String, Any?>?
    get() = (this as? Map<*, *>)?.takeIf { map -> map.keys.all { it is String } } as? Map<String, Any?>

/** The case of [E] named [name], the Kotlin name Dart sends */
private inline fun <reified E : Enum<E>> constant(
    key: String,
    name: String,
): E =
    enumValues<E>().firstOrNull { it.name == name }
        ?: throw HealthConnectException.InvalidValue("Invalid $key: $name")

internal fun Map<String, Any?>.feature(): Feature = constant("feature", string("feature"))

/** A type by its identifier, e.g. `heart_rate`; an unknown one throws **HealthConnectException.InvalidType** */
internal fun Map<String, Any?>.healthType(key: String = "type"): HealthType = HealthType.make(string(key))

internal fun Map<String, Any?>.healthTypes(): Set<HealthType> =
    strings("types").mapTo(mutableSetOf()) { HealthType.make(it) }

internal fun Map<String, Any?>.anchor(): Anchor = Anchor.make(map("anchor"))

internal fun Map<String, Any?>.range(): TimeRange = TimeRange.make(map("range"))

internal fun Map<String, Any?>.ordering(): Ordering =
    optionalString("ordering")?.let { constant<Ordering>("ordering", it) } ?: Ordering.DESCENDING

/** Optional `origins`, the `map`s of Dart's `DataOrigin`s; none reads every app */
internal fun Map<String, Any?>.origins(): Set<DataOrigin> =
    if (this["origins"] == null) emptySet() else maps("origins").mapTo(mutableSetOf()) { DataOrigin.make(it) }

internal fun Map<String, Any?>.aggregation(): Aggregation = constant("aggregation", string("aggregation"))

internal fun Map<String, Any?>.aggregations(): Set<Aggregation> =
    strings("aggregations").mapTo(mutableSetOf()) { constant("aggregation", it) }

/**
 * A sample's `map`, as Dart sends it: its `type` names the payload, read by the payload's `make(from:)`.
 * Dart's nulls mean absent, so properties with defaults take them.
 */
internal val Map<String, Any?>.sample: WritableSample
    get() {
        val map = withoutNulls
        return when (healthType()) {
            HealthType.ACTIVE_CALORIES_BURNED -> ActiveCaloriesBurned.make(map)
            HealthType.BASAL_BODY_TEMPERATURE -> BasalBodyTemperature.make(map)
            HealthType.BASAL_METABOLIC_RATE -> BasalMetabolicRate.make(map)
            HealthType.BLOOD_GLUCOSE -> BloodGlucose.make(map)
            HealthType.BLOOD_PRESSURE -> BloodPressure.make(map)
            HealthType.BODY_FAT -> BodyFat.make(map)
            HealthType.BODY_TEMPERATURE -> BodyTemperature.make(map)
            HealthType.BODY_WATER_MASS -> BodyWaterMass.make(map)
            HealthType.BONE_MASS -> BoneMass.make(map)
            HealthType.CERVICAL_MUCUS -> CervicalMucus.make(map)
            HealthType.CYCLING_PEDALING_CADENCE -> CyclingPedalingCadence.make(map)
            HealthType.DISTANCE -> Distance.make(map)
            HealthType.ELEVATION_GAINED -> ElevationGained.make(map)
            HealthType.EXERCISE_SESSION -> ExerciseSession.make(map)
            HealthType.FLOORS_CLIMBED -> FloorsClimbed.make(map)
            HealthType.HEART_RATE -> HeartRate.make(map)
            HealthType.HEART_RATE_VARIABILITY_RMSSD -> HeartRateVariabilityRmssd.make(map)
            HealthType.HEIGHT -> Height.make(map)
            HealthType.HYDRATION -> Hydration.make(map)
            HealthType.INTERMENSTRUAL_BLEEDING -> IntermenstrualBleeding.make(map)
            HealthType.LEAN_BODY_MASS -> LeanBodyMass.make(map)
            HealthType.MENSTRUATION_FLOW -> MenstruationFlow.make(map)
            HealthType.MENSTRUATION_PERIOD -> MenstruationPeriod.make(map)
            HealthType.MINDFULNESS_SESSION -> MindfulnessSession.make(map)
            HealthType.NUTRITION -> Nutrition.make(map)
            HealthType.OVULATION_TEST -> OvulationTest.make(map)
            HealthType.OXYGEN_SATURATION -> OxygenSaturation.make(map)
            HealthType.PLANNED_EXERCISE_SESSION -> PlannedExerciseSession.make(map)
            HealthType.POWER -> Power.make(map)
            HealthType.RESPIRATORY_RATE -> RespiratoryRate.make(map)
            HealthType.RESTING_HEART_RATE -> RestingHeartRate.make(map)
            HealthType.SEXUAL_ACTIVITY -> SexualActivity.make(map)
            HealthType.SKIN_TEMPERATURE -> SkinTemperature.make(map)
            HealthType.SLEEP_SESSION -> SleepSession.make(map)
            HealthType.SPEED -> Speed.make(map)
            HealthType.STEPS -> Steps.make(map)
            HealthType.STEPS_CADENCE -> StepsCadence.make(map)
            HealthType.TOTAL_CALORIES_BURNED -> TotalCaloriesBurned.make(map)
            HealthType.VO2_MAX -> Vo2Max.make(map)
            HealthType.WEIGHT -> Weight.make(map)
            HealthType.WHEELCHAIR_PUSHES -> WheelchairPushes.make(map)
        }
    }

internal fun Map<String, Any?>.samples(key: String = "samples"): List<WritableSample> = maps(key).map { it.sample }

internal fun Map<String, Any?>.timeGroup(): TimeGroup = decode(TimeGroup.serializer(), map("group"))

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

/** The map without null values, also in nested maps and lists */
private val Map<String, Any?>.withoutNulls: Map<String, Any?>
    get() = entries.filter { it.value != null }.associate { it.key to it.value.withoutNulls }

private val Any?.withoutNulls: Any?
    get() =
        when (this) {
            is Map<*, *> -> asMap?.withoutNulls ?: this
            is List<*> -> map { it.withoutNulls }
            else -> this
        }

/** Dart's nulls mean absent, so their keys are left out */
private val Map<*, *>.jsonObject: JsonObject
    get() = JsonObject(entries.filter { it.value != null }.associate { it.key.toString() to it.value.element })
