package com.kvs.health_connect_reporter

import android.content.Context
import com.kvs.healthconnectreporter.HealthConnectReporter
import com.kvs.healthconnectreporter.model.Availability

/**
 * [HealthConnect] over **HealthConnectReporter**.
 *
 * Connecting throws **HealthConnectException.NotAvailable** until Health Connect is installed and up to date, so
 * the reporter will be created lazily on the first call that needs it.
 */
class ReporterHealthConnect(
    private val context: Context,
) : HealthConnect {
    override fun availability(): Availability = HealthConnectReporter.availability(context)
}
