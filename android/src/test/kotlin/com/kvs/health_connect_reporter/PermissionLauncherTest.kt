package com.kvs.health_connect_reporter

import android.app.Activity
import android.content.Intent
import androidx.activity.result.contract.ActivityResultContract
import com.kvs.healthconnectreporter.HealthConnectException
import com.kvs.healthconnectreporter.model.Permission
import com.kvs.healthconnectreporter.model.type.AccessType
import com.kvs.healthconnectreporter.model.type.HealthType
import io.mockk.every
import io.mockk.just
import io.mockk.mockk
import io.mockk.runs
import io.mockk.slot
import io.mockk.verify
import kotlinx.coroutines.CoroutineStart
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.async
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.runTest
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertFalse
import kotlin.test.assertTrue

@OptIn(ExperimentalCoroutinesApi::class)
class PermissionLauncherTest {
    private val activity = mockk<Activity>()
    private val contract = mockk<ActivityResultContract<Set<Permission>, Set<Permission>>>()
    private val intent = mockk<Intent>()
    private val result = mockk<Intent>()
    private val requested = setOf(Permission.Data(HealthType.STEPS, AccessType.READ), Permission.ReadHistory)
    private val granted = setOf(Permission.Data(HealthType.STEPS, AccessType.READ))
    private var attached: Activity? = activity
    private val sut = PermissionLauncher { attached }
    private val requestCode = slot<Int>()

    init {
        every { contract.getSynchronousResult(activity, requested) } returns null
        every { contract.createIntent(activity, requested) } returns intent
        every { contract.parseResult(Activity.RESULT_OK, result) } returns granted
        every { activity.startActivityForResult(intent, capture(requestCode)) } just runs
    }

    @Test
    fun launch_starts_the_contract_screen_and_resumes_with_its_result() =
        runTest(UnconfinedTestDispatcher()) {
            val launched = async { sut.launch(contract, requested) }

            assertFalse(sut.onActivityResult(requestCode.captured + 1, Activity.RESULT_OK, result))
            assertTrue(sut.onActivityResult(requestCode.captured, Activity.RESULT_OK, result))
            assertEquals(granted, launched.await())
            // The request is answered once
            assertFalse(sut.onActivityResult(requestCode.captured, Activity.RESULT_OK, result))
        }

    @Test
    fun every_launch_has_a_request_code_of_its_own() =
        runTest(UnconfinedTestDispatcher()) {
            val first = async { sut.launch(contract, requested) }
            val firstCode = requestCode.captured
            val second = async { sut.launch(contract, requested) }

            assertTrue(requestCode.captured != firstCode)
            assertTrue(sut.onActivityResult(requestCode.captured, Activity.RESULT_OK, result))
            assertTrue(sut.onActivityResult(firstCode, Activity.RESULT_OK, result))
            assertEquals(granted, first.await())
            assertEquals(granted, second.await())
        }

    @Test
    fun launch_returns_a_synchronous_result_without_a_screen() =
        runTest(UnconfinedTestDispatcher()) {
            every {
                contract.getSynchronousResult(activity, requested)
            } returns ActivityResultContract.SynchronousResult(requested)

            assertEquals(requested, sut.launch(contract, requested))
            verify(exactly = 0) { activity.startActivityForResult(any(), any()) }
        }

    @Test
    fun launch_without_an_activity_fails() =
        runTest(UnconfinedTestDispatcher()) {
            attached = null

            assertFailsWith<HealthConnectException.Platform> { sut.launch(contract, requested) }
        }

    @Test
    fun launch_passes_contract_errors_on_without_a_screen() =
        runTest(UnconfinedTestDispatcher()) {
            every { contract.createIntent(activity, requested) } throws HealthConnectException.InvalidValue("missing")

            assertFailsWith<HealthConnectException.InvalidValue> { sut.launch(contract, requested) }
            verify(exactly = 0) { activity.startActivityForResult(any(), any()) }
        }

    @Test
    fun a_cancelled_launch_ignores_its_result() =
        runTest(UnconfinedTestDispatcher()) {
            val launched = async(start = CoroutineStart.UNDISPATCHED) { sut.launch(contract, requested) }

            launched.cancel()
            assertFalse(sut.onActivityResult(requestCode.captured, Activity.RESULT_OK, result))
        }
}
