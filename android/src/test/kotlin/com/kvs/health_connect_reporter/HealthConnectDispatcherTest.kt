package com.kvs.health_connect_reporter

import com.kvs.healthconnectreporter.HealthConnectException
import com.kvs.healthconnectreporter.model.Availability
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.mockk.every
import io.mockk.mockk
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

    private fun call(method: String): Reply = Reply().also { sut.onMethodCall(MethodCall(method, null), it) }

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
            every { health.availability() } throws exception

            assertEquals(Triple("availability", exception.message, details), call("availability").error)
        }
    }

    @Test
    fun errors_without_a_message_reply_their_description() {
        every { health.availability() } throws IllegalStateException()

        assertEquals("java.lang.IllegalStateException", call("availability").error?.second)
    }
}
