package com.kvs.health_connect_reporter

import android.app.Activity
import android.content.Intent
import androidx.activity.result.contract.ActivityResultContract
import com.kvs.healthconnectreporter.HealthConnectException
import com.kvs.healthconnectreporter.model.Permission
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.CancellableContinuation
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume

/**
 * Shows the permission screen of HealthConnectReporter's permission contract on the plugin's activity.
 *
 * A `FlutterActivity` has no activity result registry, so the screen starts with `startActivityForResult` and its
 * result arrives through the activity binding's result listener, which apps get without changing their activity.
 *
 * @param activity the activity the plugin is attached to, if any
 */
class PermissionLauncher(
    private val activity: () -> Activity?,
) : PluginRegistry.ActivityResultListener {
    private class Request(
        val contract: ActivityResultContract<Set<Permission>, Set<Permission>>,
        val continuation: CancellableContinuation<Set<Permission>>,
    )

    private val requests = mutableMapOf<Int, Request>()
    private var requestCode = FIRST_REQUEST_CODE

    /**
     * Requests [permissions] through [contract] and waits for the user's choice.
     *
     * @return **Set<Permission>** the permissions granted afterwards
     * @throws HealthConnectException.InvalidValue when the contract rejects the permissions
     * @throws HealthConnectException.Platform when no activity is attached
     */
    suspend fun launch(
        contract: ActivityResultContract<Set<Permission>, Set<Permission>>,
        permissions: Set<Permission>,
    ): Set<Permission> {
        val activity = activity() ?: throw HealthConnectException.Platform("No activity to show the permission screen")
        contract.getSynchronousResult(activity, permissions)?.let { return it.value }
        val intent = contract.createIntent(activity, permissions)
        val code = requestCode
        requestCode = if (requestCode == LAST_REQUEST_CODE) FIRST_REQUEST_CODE else requestCode + 1
        return suspendCancellableCoroutine { continuation ->
            requests[code] = Request(contract, continuation)
            continuation.invokeOnCancellation { requests.remove(code) }
            activity.startActivityForResult(intent, code)
        }
    }

    override fun onActivityResult(
        requestCode: Int,
        resultCode: Int,
        data: Intent?,
    ): Boolean {
        val request = requests.remove(requestCode) ?: return false
        request.continuation.resume(request.contract.parseResult(resultCode, data))
        return true
    }

    private companion object {
        // Request codes of the plugin, within the 16 bits AndroidX activities accept
        const val FIRST_REQUEST_CODE = 0x4800
        const val LAST_REQUEST_CODE = 0x48FF
    }
}
