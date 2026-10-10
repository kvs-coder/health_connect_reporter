package com.kvs.health_connect_reporter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import com.kvs.healthconnectreporter.HealthConnectException
import com.kvs.healthconnectreporter.HealthConnectReporter
import com.kvs.healthconnectreporter.model.Availability
import com.kvs.healthconnectreporter.model.Permission
import com.kvs.healthconnectreporter.model.type.Feature

/**
 * [HealthConnect] over one **HealthConnectReporter**.
 *
 * Connecting throws **HealthConnectException.NotAvailable** until Health Connect is installed and up to date, so
 * the reporter is created lazily on the first call that needs it, and again on the next call after a failure.
 *
 * @param activity the activity the plugin is attached to, if any
 * @param launcher shows the permission screen on that activity
 */
class ReporterHealthConnect(
    private val context: Context,
    private val activity: () -> Activity?,
    private val launcher: PermissionLauncher,
) : HealthConnect {
    private val reporter by lazy { HealthConnectReporter(context) }

    override fun availability(): Availability = HealthConnectReporter.availability(context)

    override suspend fun requestPermissions(permissions: Set<Permission>): Set<Permission> {
        // HealthConnectManager.requestPermissions checks the features the same way before launching
        permissions.mapNotNullTo(mutableSetOf()) { it.feature }.forEach { feature ->
            if (!reporter.manager.isFeatureAvailable(feature)) {
                throw HealthConnectException.NotAvailable("Permission needs Health Connect feature $feature")
            }
        }
        return launcher.launch(reporter.manager.permissionContract(), permissions)
    }

    override suspend fun grantedPermissions(): Set<Permission> = reporter.manager.grantedPermissions()

    override suspend fun revokeAllPermissions() = reporter.manager.revokeAllPermissions()

    override suspend fun isFeatureAvailable(feature: Feature): Boolean = reporter.manager.isFeatureAvailable(feature)

    override fun openSettings() = start(reporter.manager.settingsIntent(context))

    /**
     * The Google Play page of Health Connect, as **HealthConnectManager.installIntent** builds it: the manager needs
     * a connection, which fails exactly when Health Connect must be installed or updated.
     */
    @Suppress("UseKtx")
    override fun openInstall() =
        start(
            Intent(Intent.ACTION_VIEW)
                .setPackage(PLAY_STORE_PACKAGE)
                .setData(Uri.parse("market://details?id=$HEALTH_CONNECT_PACKAGE&url=healthconnect%3A%2F%2Fonboarding"))
                .putExtra("overlay", true)
                .putExtra("callerId", context.packageName),
        )

    /** Starts [intent] from the activity, or as a new task without one */
    private fun start(intent: Intent) {
        val activity = activity()
        if (activity != null) {
            activity.startActivity(intent)
        } else {
            context.startActivity(intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
        }
    }

    private companion object {
        const val PLAY_STORE_PACKAGE = "com.android.vending"
        const val HEALTH_CONNECT_PACKAGE = "com.google.android.apps.healthdata"
    }
}
