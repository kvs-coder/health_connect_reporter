package com.kvs.health_connect_reporter

import com.kvs.healthconnectreporter.model.Availability

/**
 * The HealthConnectReporter calls the dispatcher makes, one per Dart method.
 *
 * The dispatcher talks to this interface so its unit tests can fake Health Connect; [ReporterHealthConnect]
 * forwards it to the library.
 */
interface HealthConnect {
    fun availability(): Availability
}
