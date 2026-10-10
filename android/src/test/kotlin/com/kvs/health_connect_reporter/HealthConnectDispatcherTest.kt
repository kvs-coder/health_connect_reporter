package com.kvs.health_connect_reporter

import com.kvs.healthconnectreporter.HealthConnectException
import com.kvs.healthconnectreporter.model.Availability
import com.kvs.healthconnectreporter.model.Permission
import com.kvs.healthconnectreporter.model.type.AccessType
import com.kvs.healthconnectreporter.model.type.Feature
import com.kvs.healthconnectreporter.model.type.HealthType
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
