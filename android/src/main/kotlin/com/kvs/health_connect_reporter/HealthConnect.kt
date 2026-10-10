package com.kvs.health_connect_reporter

import com.kvs.healthconnectreporter.model.Availability
import com.kvs.healthconnectreporter.model.Permission
import com.kvs.healthconnectreporter.model.type.Feature

/**
 * The HealthConnectReporter calls the dispatcher makes, one per Dart method.
 *
 * The dispatcher talks to this interface so its unit tests can fake Health Connect; [ReporterHealthConnect]
 * forwards it to the library.
 */
interface HealthConnect {
    fun availability(): Availability

    suspend fun requestPermissions(permissions: Set<Permission>): Set<Permission>

    suspend fun grantedPermissions(): Set<Permission>

    suspend fun revokeAllPermissions()

    suspend fun isFeatureAvailable(feature: Feature): Boolean

    fun openSettings()

    fun openInstall()
}
