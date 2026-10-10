package com.kvs.health_connect_reporter_example

import android.app.Activity
import android.os.Bundle
import android.widget.TextView

/**
 * The privacy policy Health Connect links to from its permission screen. A real app explains here how it uses
 * and protects health data; Google Play reviews this screen.
 */
class PermissionsRationaleActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val padding = (24 * resources.displayMetrics.density).toInt()
        setContentView(
            TextView(this).apply {
                setPadding(padding, padding, padding, padding)
                text =
                    "Privacy policy\n\nThe HealthConnectReporter demo reads and writes Health Connect data only on " +
                    "this device to show what the plugin does. It sends no data anywhere."
            },
        )
    }
}
