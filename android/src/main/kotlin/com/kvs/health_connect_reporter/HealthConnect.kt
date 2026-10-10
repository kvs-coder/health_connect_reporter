package com.kvs.health_connect_reporter

import com.kvs.healthconnectreporter.model.Aggregate
import com.kvs.healthconnectreporter.model.Availability
import com.kvs.healthconnectreporter.model.DataOrigin
import com.kvs.healthconnectreporter.model.Ordering
import com.kvs.healthconnectreporter.model.Page
import com.kvs.healthconnectreporter.model.Permission
import com.kvs.healthconnectreporter.model.TimeGroup
import com.kvs.healthconnectreporter.model.TimeRange
import com.kvs.healthconnectreporter.model.payload.Sample
import com.kvs.healthconnectreporter.model.payload.WritableSample
import com.kvs.healthconnectreporter.model.type.Aggregation
import com.kvs.healthconnectreporter.model.type.Feature
import com.kvs.healthconnectreporter.model.type.HealthType

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

    suspend fun read(
        type: HealthType,
        range: TimeRange,
        ordering: Ordering,
        limit: Int?,
        origins: Set<DataOrigin>,
    ): List<Sample>

    suspend fun readPage(
        type: HealthType,
        range: TimeRange,
        pageSize: Int,
        pageToken: String?,
        ordering: Ordering,
        origins: Set<DataOrigin>,
    ): Page

    suspend fun readById(
        type: HealthType,
        id: String,
    ): Sample

    suspend fun aggregate(
        aggregation: Aggregation,
        range: TimeRange,
        origins: Set<DataOrigin>,
    ): Aggregate

    suspend fun aggregateGroups(
        aggregations: Set<Aggregation>,
        range: TimeRange,
        group: TimeGroup,
        origins: Set<DataOrigin>,
    ): List<Aggregate>

    suspend fun insert(samples: List<WritableSample>): List<WritableSample>

    suspend fun update(samples: List<WritableSample>)

    suspend fun delete(sample: WritableSample)

    suspend fun deleteByIds(
        type: HealthType,
        ids: List<String>,
        clientRecordIds: List<String>,
    )

    suspend fun deleteByRange(
        type: HealthType,
        range: TimeRange,
    )
}
