import 'package:flutter/material.dart';
import 'package:health_connect_reporter/health_connect_reporter.dart';
import 'package:health_connect_reporter/model/availability.dart';

void main() => runApp(const DemoApp());

/// Shows whether Health Connect is available; the demo catalog follows with the services.
class DemoApp extends StatelessWidget {
  const DemoApp({
    super.key,
    this.availability = HealthConnectReporter.availability,
  });

  /// The availability check, replaced in tests
  final Future<Availability> Function() availability;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'HealthConnectReporter',
    home: Scaffold(
      appBar: AppBar(title: const Text('HealthConnectReporter')),
      body: Center(
        child: FutureBuilder<Availability>(
          future: availability(),
          builder: (context, snapshot) => Text(
            snapshot.hasError
                ? 'Error: ${snapshot.error}'
                : 'Health Connect: ${snapshot.data?.name ?? '…'}',
          ),
        ),
      ),
    ),
  );
}
