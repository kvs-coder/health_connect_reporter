package com.kvs.health_connect_reporter

import com.kvs.healthconnectreporter.model.Permission
import com.kvs.healthconnectreporter.model.type.Feature

/** **Feature?** the Health Connect feature the permission needs, as HealthConnectReporter checks it */
internal val Permission.feature: Feature?
    get() =
        when (this) {
            is Permission.Data -> healthType.feature
            Permission.ReadInBackground -> Feature.READ_HEALTH_DATA_IN_BACKGROUND
            Permission.ReadHistory -> Feature.READ_HEALTH_DATA_HISTORY
            Permission.WriteExerciseRoute -> null
        }
