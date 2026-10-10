import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'model/availability.dart';
import 'model/decorator/platform.dart';

/// [HealthConnectReporter] class.
/// Reads, writes and observes Android Health Connect data
/// through the Kotlin library HealthConnectReporter
/// https://github.com/kvs-coder/HealthConnectReporter.
/// Invokes calls to native side. Channel: [health_connect_reporter_method_channel]
/// All responses are the library's JSON payloads, parsed into the models
/// of `health_connect_reporter/model/`.
///
/// The list of Platform methods:
/// - [availability]
///
/// Health Connect is available only on Android: on any other platform
/// [availability] returns [Availability.unavailable] and every other method
/// throws an [UnsupportedError].
/// For Apple Health on iOS see https://pub.dev/packages/health_kit_reporter,
/// for Samsung Health see https://pub.dev/packages/samsung_health_reporter.
///
/// The app needs Android 8 (API 26) or later; Health Connect is part of
/// Android 14+ and an app from Google Play on Android 9–13.
///
/// Timestamps are epoch milliseconds, as in the library.
/// Errors arrive as [PlatformException]s whose code is the method name,
/// whose message is the library's error message and whose details name the error:
/// `NotAuthorized`, `InvalidType`, `InvalidValue`, `NotAvailable`,
/// `AnchorExpired` or `Platform`.
///
class HealthConnectReporter {
  /// [MethodChannel] link to `HealthConnectReporterPlugin.kt`
  ///
  static const MethodChannel _channel =
      MethodChannel('health_connect_reporter_method_channel');

  /// Checks whether Health Connect can be used on this device.
  ///
  /// Returns [Availability.unavailable] without a channel call
  /// on any platform but Android.
  ///
  static Future<Availability> availability() async {
    if (!runsOn(TargetPlatform.android)) return Availability.unavailable;
    final reply = await _channel.invokeMethod<String>('availability');
    return Availability.from(reply == null ? '' : '${jsonDecode(reply)}');
  }
}
