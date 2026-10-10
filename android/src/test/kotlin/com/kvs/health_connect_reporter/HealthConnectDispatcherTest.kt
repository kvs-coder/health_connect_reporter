package com.kvs.health_connect_reporter

import com.kvs.healthconnectreporter.HealthConnectException
import com.kvs.healthconnectreporter.model.Aggregate
import com.kvs.healthconnectreporter.model.Availability
import com.kvs.healthconnectreporter.model.DataOrigin
import com.kvs.healthconnectreporter.model.Ordering
import com.kvs.healthconnectreporter.model.Page
import com.kvs.healthconnectreporter.model.Permission
import com.kvs.healthconnectreporter.model.TimeGroup
import com.kvs.healthconnectreporter.model.TimeRange
import com.kvs.healthconnectreporter.model.payload.Steps
import com.kvs.healthconnectreporter.model.payload.Weight
import com.kvs.healthconnectreporter.model.type.AccessType
import com.kvs.healthconnectreporter.model.type.Aggregation
import com.kvs.healthconnectreporter.model.type.Feature
import com.kvs.healthconnectreporter.model.type.HealthType
import com.kvs.healthconnectreporter.model.type.TimeGroupUnit
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.mockk.coEvery
import io.mockk.coVerify
import io.mockk.every
import io.mockk.just
import io.mockk.mockk
import io.mockk.runs
import io.mockk.verify
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

private const val START = 1_760_000_000_000L
private const val END = 1_760_003_600_000L

@OptIn(ExperimentalCoroutinesApi::class)
class HealthConnectDispatcherTest {
    private val health = mockk<HealthConnect>()
    private val sut = HealthConnectDispatcher(health, TestScope(UnconfinedTestDispatcher()))

    private val permissionMaps =
        listOf(
            mapOf("type" to "data", "healthType" to "STEPS", "access" to "READ"),
            mapOf("type" to "read_in_background"),
            mapOf("type" to "read_history"),
            mapOf("type" to "write_exercise_route"),
        )
    private val permissions =
        setOf(
            Permission.Data(HealthType.STEPS, AccessType.READ),
            Permission.ReadInBackground,
            Permission.ReadHistory,
            Permission.WriteExerciseRoute,
        )
    private val permissionsJson =
        "[{\"type\":\"data\",\"healthType\":\"STEPS\",\"access\":\"READ\"},{\"type\":\"read_in_background\"}," +
            "{\"type\":\"read_history\"},{\"type\":\"write_exercise_route\"}]"

    private val steps = Steps(START, END, Steps.Harmonized(1200), clientRecordId = "client-1")
    private val weight = Weight(START, harmonized = Weight.Harmonized(72.5))
    private val range = TimeRange(START, END)
    private val rangeMap = mapOf("startTimestamp" to START, "endTimestamp" to END)
    private val origins = setOf(DataOrigin("com.example"))
    private val originMaps = listOf(mapOf("packageName" to "com.example"))
    private val aggregate = Aggregate(Aggregation.STEPS_COUNT_TOTAL, START, END, 1200.0)

    /** Records the reply of one call */
    private class Reply : MethodChannel.Result {
        var value: Any? = null
        var error: Triple<String, String?, Any?>? = null
        var notImplemented = false

        override fun success(result: Any?) {
            value = result
        }

        override fun error(
            errorCode: String,
            errorMessage: String?,
            errorDetails: Any?,
        ) {
            error = Triple(errorCode, errorMessage, errorDetails)
        }

        override fun notImplemented() {
            notImplemented = true
        }
    }

    private fun call(
        method: String,
        arguments: Any? = null,
    ): Reply = Reply().also { sut.onMethodCall(MethodCall(method, arguments), it) }

    @Test
    fun availability_replies_the_library_json() {
        val expected =
            mapOf(
                Availability.AVAILABLE to "\"available\"",
                Availability.UPDATE_REQUIRED to "\"update_required\"",
                Availability.UNAVAILABLE to "\"unavailable\"",
            )
        expected.forEach { (availability, json) ->
            every { health.availability() } returns availability

            assertEquals(json, call("availability").value)
        }
    }

    @Test
    fun request_permissions_reads_every_permission_and_replies_the_granted_ones() {
        coEvery { health.requestPermissions(permissions) } returns permissions

        assertEquals(permissionsJson, call("requestPermissions", mapOf("permissions" to permissionMaps)).value)
    }

    @Test
    fun request_permissions_rejects_invalid_permissions() {
        val invalid =
            listOf(
                null,
                mapOf("permissions" to "STEPS"),
                mapOf("permissions" to listOf(mapOf("type" to "data", "healthType" to "steps", "access" to "READ"))),
                mapOf("permissions" to listOf(mapOf("type" to "write_everything"))),
                mapOf("permissions" to listOf(mapOf(1 to "data"))),
            )
        invalid.forEach { arguments ->
            assertEquals("InvalidValue", call("requestPermissions", arguments).error?.third, "$arguments")
        }
        coVerify(exactly = 0) { health.requestPermissions(any()) }
    }

    @Test
    fun granted_permissions_replies_the_library_json() {
        coEvery { health.grantedPermissions() } returns permissions

        assertEquals(permissionsJson, call("grantedPermissions").value)
        coEvery { health.grantedPermissions() } returns emptySet()
        assertEquals("[]", call("grantedPermissions").value)
    }

    @Test
    fun revoke_all_permissions_replies_true() {
        coEvery { health.revokeAllPermissions() } just runs

        assertEquals(true, call("revokeAllPermissions").value)
        coVerify { health.revokeAllPermissions() }
    }

    @Test
    fun is_feature_available_reads_the_feature_by_its_kotlin_name() {
        Feature.entries.forEach { feature ->
            coEvery { health.isFeatureAvailable(feature) } returns (feature == Feature.SKIN_TEMPERATURE)

            assertEquals(
                feature == Feature.SKIN_TEMPERATURE,
                call("isFeatureAvailable", mapOf("feature" to feature.name)).value,
            )
        }
        assertEquals("InvalidValue", call("isFeatureAvailable", mapOf("feature" to "TELEPORT")).error?.third)
        assertEquals("InvalidValue", call("isFeatureAvailable").error?.third)
    }

    @Test
    fun screens_open_and_reply_true() {
        every { health.openSettings() } just runs
        every { health.openInstall() } just runs

        assertEquals(true, call("openSettings").value)
        assertEquals(true, call("openInstall").value)
        verify { health.openSettings() }
        verify { health.openInstall() }
    }

    @Test
    fun read_sends_every_argument_and_replies_mixed_samples() {
        coEvery { health.read(HealthType.STEPS, range, Ordering.ASCENDING, 10, origins) } returns listOf(steps, weight)

        val reply =
            call(
                "read",
                mapOf(
                    "type" to "steps",
                    "range" to rangeMap,
                    "ordering" to "ASCENDING",
                    "limit" to 10,
                    "origins" to originMaps,
                ),
            )

        assertEquals("[${steps.json},${weight.json}]", reply.value)
    }

    @Test
    fun read_defaults_to_newest_first_from_every_app() {
        coEvery { health.read(HealthType.WEIGHT, range, Ordering.DESCENDING, null, emptySet()) } returns emptyList()

        assertEquals("[]", call("read", mapOf("type" to "weight", "range" to rangeMap)).value)
    }

    @Test
    fun read_page_sends_the_page_and_replies_its_token() {
        coEvery {
            health.readPage(HealthType.STEPS, range, 2, "token", Ordering.DESCENDING, emptySet())
        } returns Page(listOf(steps), "next")
        coEvery {
            health.readPage(HealthType.STEPS, range, 1000, null, Ordering.DESCENDING, emptySet())
        } returns Page(emptyList())

        assertEquals(
            Page(listOf(steps), "next").json,
            call(
                "readPage",
                mapOf("type" to "steps", "range" to rangeMap, "pageSize" to 2, "pageToken" to "token"),
            ).value,
        )
        assertEquals("{\"items\":[]}", call("readPage", mapOf("type" to "steps", "range" to rangeMap)).value)
    }

    @Test
    fun read_by_id_replies_the_sample() {
        coEvery { health.readById(HealthType.STEPS, "id-1") } returns steps

        assertEquals(steps.json, call("readById", mapOf("type" to "steps", "id" to "id-1")).value)
    }

    @Test
    fun aggregate_sends_the_kotlin_name_and_replies_the_aggregate() {
        coEvery { health.aggregate(Aggregation.STEPS_COUNT_TOTAL, range, origins) } returns aggregate

        val reply =
            call(
                "aggregate",
                mapOf("aggregation" to "STEPS_COUNT_TOTAL", "range" to rangeMap, "origins" to originMaps),
            )

        assertEquals(aggregate.json, reply.value)
    }

    @Test
    fun aggregate_groups_reads_both_time_groups() {
        val aggregations = setOf(Aggregation.STEPS_COUNT_TOTAL, Aggregation.HEART_RATE_BPM_AVG)
        val groups =
            mapOf(
                mapOf("type" to "duration", "durationMillis" to 900_000) to TimeGroup.Duration(900_000),
                mapOf("type" to "period", "unit" to "DAILY", "count" to 2, "zoneId" to "Europe/Berlin") to
                    TimeGroup.Period(TimeGroupUnit.DAILY, 2, "Europe/Berlin"),
                mapOf("type" to "period", "unit" to "WEEKLY", "count" to 1, "zoneId" to null) to
                    TimeGroup.Period(TimeGroupUnit.WEEKLY),
            )
        groups.forEach { (map, group) ->
            coEvery { health.aggregateGroups(aggregations, range, group, emptySet()) } returns listOf(aggregate)

            val reply =
                call(
                    "aggregateGroups",
                    mapOf(
                        "aggregations" to listOf("STEPS_COUNT_TOTAL", "HEART_RATE_BPM_AVG"),
                        "range" to rangeMap,
                        "group" to map,
                    ),
                )

            assertEquals("[${aggregate.json}]", reply.value, "$map")
        }
    }

    @Test
    fun reader_rejects_invalid_arguments() {
        val invalid =
            listOf(
                "read" to mapOf("type" to "steps"),
                "read" to mapOf("type" to "steps", "range" to mapOf("startTimestamp" to END, "endTimestamp" to START)),
                "readPage" to mapOf("type" to "steps", "range" to rangeMap, "ordering" to "RANDOM"),
                "readById" to mapOf("type" to "steps"),
                "aggregate" to mapOf("aggregation" to "STEPS_COUNT", "range" to rangeMap),
                "aggregateGroups" to mapOf("aggregations" to listOf("STEPS_COUNT_TOTAL"), "range" to rangeMap),
                "aggregateGroups" to
                    mapOf(
                        "aggregations" to listOf("STEPS_COUNT_TOTAL"),
                        "range" to rangeMap,
                        "group" to mapOf("type" to "duration", "durationMillis" to 0),
                    ),
            )
        invalid.forEach { (method, arguments) ->
            assertEquals("InvalidValue", call(method, arguments).error?.third, "$method $arguments")
        }
        assertEquals("InvalidType", call("read", mapOf("type" to "STEPS", "range" to rangeMap)).error?.third)
    }

    @Test
    fun arguments_that_are_no_map_are_invalid() {
        assertEquals("InvalidValue", call("grantedPermissions", listOf("STEPS")).error?.third)
    }

    @Test
    fun unknown_method_is_not_implemented() {
        assertTrue(call("unknown").notImplemented)
    }

    @Test
    fun errors_reply_the_method_the_message_and_the_kind() {
        val expected =
            mapOf(
                HealthConnectException.NotAuthorized("a") to "NotAuthorized",
                HealthConnectException.InvalidType("b") to "InvalidType",
                HealthConnectException.InvalidValue("c") to "InvalidValue",
                HealthConnectException.NotAvailable("d") to "NotAvailable",
                HealthConnectException.AnchorExpired("e") to "AnchorExpired",
                HealthConnectException.Platform("f") to "Platform",
                IllegalStateException("g") to "IllegalStateException",
            )
        expected.forEach { (exception, details) ->
            coEvery { health.grantedPermissions() } throws exception

            assertEquals(Triple("grantedPermissions", exception.message, details), call("grantedPermissions").error)
        }
    }

    @Test
    fun errors_without_a_message_reply_their_description() {
        every { health.availability() } throws IllegalStateException()

        assertEquals("java.lang.IllegalStateException", call("availability").error?.second)
    }
}
