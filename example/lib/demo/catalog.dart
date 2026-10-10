import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_connect_reporter/health_connect_reporter.dart';
import 'package:health_connect_reporter/model/aggregate.dart';
import 'package:health_connect_reporter/model/anchor.dart';
import 'package:health_connect_reporter/model/data_origin.dart';
import 'package:health_connect_reporter/model/payload/active_calories_burned.dart';
import 'package:health_connect_reporter/model/payload/basal_body_temperature.dart';
import 'package:health_connect_reporter/model/payload/basal_metabolic_rate.dart';
import 'package:health_connect_reporter/model/payload/blood_glucose.dart';
import 'package:health_connect_reporter/model/payload/blood_pressure.dart';
import 'package:health_connect_reporter/model/payload/body_fat.dart';
import 'package:health_connect_reporter/model/payload/body_temperature.dart';
import 'package:health_connect_reporter/model/payload/body_water_mass.dart';
import 'package:health_connect_reporter/model/payload/bone_mass.dart';
import 'package:health_connect_reporter/model/payload/cervical_mucus.dart';
import 'package:health_connect_reporter/model/payload/cycling_pedaling_cadence.dart';
import 'package:health_connect_reporter/model/payload/distance.dart';
import 'package:health_connect_reporter/model/payload/elevation_gained.dart';
import 'package:health_connect_reporter/model/payload/exercise_session.dart';
import 'package:health_connect_reporter/model/payload/floors_climbed.dart';
import 'package:health_connect_reporter/model/payload/heart_rate.dart';
import 'package:health_connect_reporter/model/payload/heart_rate_variability_rmssd.dart';
import 'package:health_connect_reporter/model/payload/height.dart';
import 'package:health_connect_reporter/model/payload/hydration.dart';
import 'package:health_connect_reporter/model/payload/intermenstrual_bleeding.dart';
import 'package:health_connect_reporter/model/payload/lean_body_mass.dart';
import 'package:health_connect_reporter/model/payload/menstruation_flow.dart';
import 'package:health_connect_reporter/model/payload/menstruation_period.dart';
import 'package:health_connect_reporter/model/payload/mindfulness_session.dart';
import 'package:health_connect_reporter/model/payload/nutrition.dart';
import 'package:health_connect_reporter/model/payload/ovulation_test.dart';
import 'package:health_connect_reporter/model/payload/oxygen_saturation.dart';
import 'package:health_connect_reporter/model/payload/planned_exercise_session.dart';
import 'package:health_connect_reporter/model/payload/power.dart';
import 'package:health_connect_reporter/model/payload/respiratory_rate.dart';
import 'package:health_connect_reporter/model/payload/resting_heart_rate.dart';
import 'package:health_connect_reporter/model/payload/sexual_activity.dart';
import 'package:health_connect_reporter/model/payload/skin_temperature.dart';
import 'package:health_connect_reporter/model/payload/sleep_session.dart';
import 'package:health_connect_reporter/model/payload/speed.dart';
import 'package:health_connect_reporter/model/payload/steps.dart';
import 'package:health_connect_reporter/model/payload/steps_cadence.dart';
import 'package:health_connect_reporter/model/payload/total_calories_burned.dart';
import 'package:health_connect_reporter/model/payload/vo2_max.dart';
import 'package:health_connect_reporter/model/payload/weight.dart';
import 'package:health_connect_reporter/model/payload/wheelchair_pushes.dart';
import 'package:health_connect_reporter/model/payload/sample.dart';
import 'package:health_connect_reporter/model/permission.dart';
import 'package:health_connect_reporter/model/time_group.dart';
import 'package:health_connect_reporter/model/time_range.dart';
import 'package:health_connect_reporter/model/type/aggregation.dart';
import 'package:health_connect_reporter/model/type/blood_pressure_measurement_location.dart';
import 'package:health_connect_reporter/model/type/body_position.dart';
import 'package:health_connect_reporter/model/type/body_temperature_measurement_location.dart';
import 'package:health_connect_reporter/model/type/cervical_mucus_appearance.dart';
import 'package:health_connect_reporter/model/type/cervical_mucus_sensation.dart';
import 'package:health_connect_reporter/model/type/exercise_phase.dart';
import 'package:health_connect_reporter/model/type/exercise_segment_type.dart';
import 'package:health_connect_reporter/model/type/exercise_type.dart';
import 'package:health_connect_reporter/model/type/feature.dart';
import 'package:health_connect_reporter/model/type/health_type.dart';
import 'package:health_connect_reporter/model/type/meal_type.dart';
import 'package:health_connect_reporter/model/type/menstruation_flow_type.dart';
import 'package:health_connect_reporter/model/type/mindfulness_session_type.dart';
import 'package:health_connect_reporter/model/type/ordering.dart';
import 'package:health_connect_reporter/model/type/ovulation_test_result.dart';
import 'package:health_connect_reporter/model/type/protection_used.dart';
import 'package:health_connect_reporter/model/type/relation_to_meal.dart';
import 'package:health_connect_reporter/model/type/skin_temperature_measurement_location.dart';
import 'package:health_connect_reporter/model/type/sleep_stage_type.dart';
import 'package:health_connect_reporter/model/type/specimen_source.dart';
import 'package:health_connect_reporter/model/type/time_group_unit.dart';
import 'package:health_connect_reporter/model/type/vo2_max_measurement_method.dart';

import 'catalog_bloc.dart';
import 'demo_row.dart';

/// Every public method of [HealthConnectReporter], grouped like the library:
/// manager, reader, aggregates, writer and observer.
class Catalog {
  Catalog();

  /// This app, to read only what it wrote
  static const _origin = DataOrigin(
    packageName: 'com.kvs.health_connect_reporter_example',
  );

  /// Samples the writer rows inserted, by type
  final _inserted = <HealthType, WritableSample>{};

  /// The anchor of the observer rows
  Anchor? _anchor;

  static int get _now => DateTime.now().millisecondsSinceEpoch;

  static TimeRange get _today => TimeRange.lastDays(1);

  static TimeRange get _lastWeek => TimeRange.lastDays(7);

  static String _json(Object? value) =>
      const JsonEncoder.withIndent('  ').convert(value);

  static String _samples(List<Sample> samples) =>
      '${samples.length} samples\n${_json(samples.take(3).map((e) => e.map).toList())}';

  /// The features this Health Connect supports
  static Future<Set<Feature>> _features() async => {
    for (final feature in Feature.values)
      if (await HealthConnectReporter.isFeatureAvailable(feature)) feature,
  };

  /// The types whose feature this Health Connect supports
  static Future<List<HealthType>> _supportedTypes() async {
    final features = await _features();
    return HealthType.values
        .where((e) => e.feature == null || features.contains(e.feature))
        .toList();
  }

  /// Every permission of the demo whose feature the device supports:
  /// read and write of every type, reading in the background and history,
  /// and writing exercise routes
  static Future<Set<Permission>> _permissions() async {
    final features = await _features();
    return {
      ...Permission.of(await _supportedTypes()),
      if (features.contains(Feature.readHealthDataInBackground))
        const PermissionReadInBackground(),
      if (features.contains(Feature.readHealthDataHistory))
        const PermissionReadHistory(),
      const PermissionWriteExerciseRoute(),
    };
  }

  static String _aggregates(List<Aggregate> aggregates) => aggregates
      .map(
        (e) =>
            '${DateTime.fromMillisecondsSinceEpoch(e.startTimestamp)}: '
            '${e.aggregation.value} ${e.value ?? '-'} ${e.unit}',
      )
      .join('\n');

  late final List<DemoSection> sections = [
    DemoSection(
      'Manager',
      [
        DemoRow(
          'availability',
          'Whether Health Connect can be used',
          run: () async => (await HealthConnectReporter.availability()).value,
        ),
        DemoRow(
          'requestPermissions',
          'Read and write every type whose feature the device has',
          run: () async {
            final permissions = await _permissions();
            final granted = await HealthConnectReporter.requestPermissions(
              permissions,
            );
            return '${granted.length} of ${permissions.length} granted';
          },
        ),
        DemoRow(
          'grantedPermissions',
          'The permissions granted to this app',
          run: () async {
            final granted = await HealthConnectReporter.grantedPermissions();
            return '${granted.length} granted\n'
                '${granted.map((e) => _json(e.map)).join('\n')}';
          },
        ),
        DemoRow(
          'isFeatureAvailable',
          'Every Health Connect feature',
          run: () async {
            final lines = [
              for (final feature in Feature.values)
                '${feature.value}: '
                    '${await HealthConnectReporter.isFeatureAvailable(feature)}',
            ];
            return lines.join('\n');
          },
        ),
        DemoRow(
          'openSettings',
          "Health Connect's data management screen",
          run: () async => '${await HealthConnectReporter.openSettings()}',
        ),
        DemoRow(
          'openInstall',
          'Health Connect on Google Play',
          run: () async => '${await HealthConnectReporter.openInstall()}',
        ),
        DemoRow(
          'revokeAllPermissions',
          'Revoke every permission of this app',
          run: () async =>
              '${await HealthConnectReporter.revokeAllPermissions()}',
        ),
      ],
      icon: Icons.admin_panel_settings_rounded,
      footer: 'The app declares every permission in its manifest',
    ),
    DemoSection(
      'Reader',
      [
        for (final type in HealthType.values)
          DemoRow(
            'read ${type.identifier}',
            'The last 7 days',
            run: () async =>
                _samples(await HealthConnectReporter.read(type, _lastWeek)),
          ),
        DemoRow(
          'read with origins',
          "Today's steps this app wrote, oldest first",
          run: () async => _samples(
            await HealthConnectReporter.read(
              HealthType.steps,
              _today,
              ordering: Ordering.ascending,
              limit: 10,
              origins: {_origin},
            ),
          ),
        ),
        DemoRow(
          'readPage',
          'Steps of the last 7 days, two pages of 5',
          run: () async {
            final first = await HealthConnectReporter.readPage(
              HealthType.steps,
              _lastWeek,
              pageSize: 5,
            );
            final token = first.nextPageToken;
            if (token == null) return '1 page: ${first.items.length} samples';
            final second = await HealthConnectReporter.readPage(
              HealthType.steps,
              _lastWeek,
              pageSize: 5,
              pageToken: token,
            );
            return '2 pages: ${first.items.length} + ${second.items.length} samples';
          },
        ),
        DemoRow(
          'readById',
          'The newest steps record of the last 7 days, read again by its id',
          run: () async {
            final newest = await HealthConnectReporter.read(
              HealthType.steps,
              _lastWeek,
              limit: 1,
            );
            final id = newest.firstOrNull?.id;
            if (id == null) return 'No steps to read';
            return _json(
              (await HealthConnectReporter.readById(HealthType.steps, id)).map,
            );
          },
        ),
      ],
      icon: Icons.menu_book_rounded,
      footer:
          'Without READ_HEALTH_DATA_HISTORY Health Connect returns data '
          'from 30 days before the first grant onwards',
    ),
    DemoSection('Aggregates', [
      for (final aggregation in Aggregation.values)
        DemoRow(
          'aggregate ${aggregation.value}',
          'The last 7 days',
          run: () async {
            final aggregate = await HealthConnectReporter.aggregate(
              aggregation,
              _lastWeek,
            );
            return '${aggregate.value ?? '-'} ${aggregate.unit}';
          },
        ),
      DemoRow(
        'aggregateGroups by duration',
        'Steps per hour today',
        run: () async => _aggregates(
          await HealthConnectReporter.aggregateGroups(
            {Aggregation.stepsCountTotal},
            _today,
            TimeGroupDuration(
              durationMillis: const Duration(hours: 1).inMilliseconds,
            ),
          ),
        ),
      ),
      DemoRow(
        'aggregateGroups by period',
        "Steps and average heart rate per day of the last 7 days, in the device's zone",
        run: () async => _aggregates(
          await HealthConnectReporter.aggregateGroups(
            {Aggregation.stepsCountTotal, Aggregation.heartRateBpmAvg},
            _lastWeek,
            TimeGroupPeriod(unit: TimeGroupUnit.daily),
          ),
        ),
      ),
    ], icon: Icons.functions_rounded),
    DemoSection(
      'Writer',
      [
        DemoRow(
          'insert',
          'One sample of every type whose feature the device has',
          run: () async {
            final types = await _supportedTypes();
            final inserted = await HealthConnectReporter.insert(
              types.map((type) => _sample(type, _now)).toList(),
            );
            for (final sample in inserted) {
              _inserted[sample.healthType] = sample;
            }
            return '${inserted.length} samples inserted';
          },
        ),
        for (final type in HealthType.values)
          DemoRow(
            'insert ${type.identifier}',
            'One sample',
            run: () async {
              final inserted = await HealthConnectReporter.insert([
                _sample(type, _now),
              ]);
              _inserted[type] = inserted.single;
              return _json(inserted.single.map);
            },
          ),
        DemoRow(
          'update',
          'The inserted steps to 1300, by its client record id and a higher version',
          run: () async {
            final steps = _inserted[HealthType.steps];
            if (steps is! Steps) return 'Insert steps first';
            final updated = Steps(
              startTimestamp: steps.startTimestamp,
              endTimestamp: steps.endTimestamp,
              harmonized: const StepsHarmonized(count: 1300),
              id: steps.id,
              clientRecordId: steps.clientRecordId,
              clientRecordVersion: (steps.clientRecordVersion ?? 0) + 1,
            );
            await HealthConnectReporter.update([updated]);
            _inserted[HealthType.steps] = updated;
            return 'Updated';
          },
        ),
        DemoRow(
          'deleteByIds',
          'The inserted weight, by its id and client record id',
          run: () async {
            final weight = _inserted.remove(HealthType.weight);
            if (weight == null) return 'Insert a weight first';
            return '${await HealthConnectReporter.deleteByIds(HealthType.weight, ids: [?weight.id], clientRecordIds: [?weight.clientRecordId])}';
          },
        ),
        DemoRow(
          'deleteByRange',
          'Every hydration this app wrote today',
          run: () async =>
              '${await HealthConnectReporter.deleteByRange(HealthType.hydration, _today)}',
        ),
        DemoRow(
          'delete',
          'Every sample the writer rows inserted',
          run: () async {
            final samples = _inserted.values.toList();
            for (final sample in samples) {
              await HealthConnectReporter.delete(sample);
            }
            _inserted.clear();
            return '${samples.length} deleted';
          },
        ),
      ],
      icon: Icons.edit_note_rounded,
      footer:
          'Samples get a random client record id on insert, so they can be '
          'updated and deleted without reading them back',
    ),
    DemoSection(
      'Observer',
      [
        DemoRow(
          'anchor',
          'The current end of the steps and heart rate history',
          run: () async {
            final anchor = await HealthConnectReporter.anchor({
              HealthType.steps,
              HealthType.heartRate,
            });
            _anchor = anchor;
            return anchor.token;
          },
        ),
        DemoRow(
          'changes',
          'Steps and heart rate changes since the anchor',
          run: () async {
            final anchor =
                _anchor ??
                await HealthConnectReporter.anchor({
                  HealthType.steps,
                  HealthType.heartRate,
                });
            final changes = await HealthConnectReporter.changes(anchor);
            _anchor = changes.anchor;
            return '${changes.upserted.length} upserted, '
                '${changes.deletedIds.length} deleted';
          },
        ),
        DemoRow(
          'observe',
          'Steps changes, polled every 10 s',
          listen: _observe,
        ),
      ],
      icon: Icons.visibility_rounded,
      footer: 'Health Connect keeps changes for 30 days',
    ),
  ];

  /// Takes an anchor, then polls the steps changes since it every 10 s
  /// until cancelled
  static StreamSubscription<String> _observe(void Function(String) report) {
    StreamSubscription<dynamic>? observing;
    var cancelled = false;
    late final StreamController<String> updates;
    updates = StreamController<String>(
      onListen: () async {
        try {
          final anchor = await HealthConnectReporter.anchor({HealthType.steps});
          if (cancelled) return;
          observing = HealthConnectReporter.observe(
            anchor,
            interval: const Duration(seconds: 10),
            onUpdate: (changes) => updates.add(
              '${changes.upserted.length} upserted, '
              '${changes.deletedIds.length} deleted',
            ),
            onError: (Object error) => updates.add(CatalogBloc.describe(error)),
          );
        } catch (error) {
          updates.add(CatalogBloc.describe(error));
        }
      },
      onCancel: () async {
        cancelled = true;
        await observing?.cancel();
      },
    );
    return updates.stream.listen(report);
  }

  /// One plausible sample of a [type] ending at [now]
  static WritableSample _sample(HealthType type, int now) {
    final start = now - const Duration(minutes: 30).inMilliseconds;
    final mid = now - const Duration(minutes: 15).inMilliseconds;
    switch (type) {
      case HealthType.activeCaloriesBurned:
        return ActiveCaloriesBurned(
          startTimestamp: start,
          endTimestamp: now,
          harmonized: const ActiveCaloriesBurnedHarmonized(energy: 120),
        );
      case HealthType.basalBodyTemperature:
        return BasalBodyTemperature(
          startTimestamp: now,
          harmonized: const BasalBodyTemperatureHarmonized(
            temperature: 36.6,
            measurementLocation: BodyTemperatureMeasurementLocation.mouth,
          ),
        );
      case HealthType.basalMetabolicRate:
        return BasalMetabolicRate(
          startTimestamp: now,
          harmonized: const BasalMetabolicRateHarmonized(
            basalMetabolicRate: 70,
          ),
        );
      case HealthType.bloodGlucose:
        return BloodGlucose(
          startTimestamp: now,
          harmonized: const BloodGlucoseHarmonized(
            level: 5.5,
            specimenSource: SpecimenSource.capillaryBlood,
            mealType: MealType.breakfast,
            relationToMeal: RelationToMeal.afterMeal,
          ),
        );
      case HealthType.bloodPressure:
        return BloodPressure(
          startTimestamp: now,
          harmonized: const BloodPressureHarmonized(
            systolic: 120,
            diastolic: 80,
            bodyPosition: BodyPosition.sittingDown,
            measurementLocation: BloodPressureMeasurementLocation.leftUpperArm,
          ),
        );
      case HealthType.bodyFat:
        return BodyFat(
          startTimestamp: now,
          harmonized: const BodyFatHarmonized(percentage: 18.5),
        );
      case HealthType.bodyTemperature:
        return BodyTemperature(
          startTimestamp: now,
          harmonized: const BodyTemperatureHarmonized(temperature: 36.8),
        );
      case HealthType.bodyWaterMass:
        return BodyWaterMass(
          startTimestamp: now,
          harmonized: const BodyWaterMassHarmonized(mass: 40),
        );
      case HealthType.boneMass:
        return BoneMass(
          startTimestamp: now,
          harmonized: const BoneMassHarmonized(mass: 3.2),
        );
      case HealthType.cervicalMucus:
        return CervicalMucus(
          startTimestamp: now,
          harmonized: const CervicalMucusHarmonized(
            appearance: CervicalMucusAppearance.creamy,
            sensation: CervicalMucusSensation.medium,
          ),
        );
      case HealthType.cyclingPedalingCadence:
        return CyclingPedalingCadence(
          startTimestamp: start,
          endTimestamp: now,
          harmonized: CyclingPedalingCadenceHarmonized(
            series: [
              CyclingPedalingCadenceSeries(
                timestamp: mid,
                revolutionsPerMinute: 80,
              ),
            ],
          ),
        );
      case HealthType.distance:
        return Distance(
          startTimestamp: start,
          endTimestamp: now,
          harmonized: const DistanceHarmonized(distance: 1500),
        );
      case HealthType.elevationGained:
        return ElevationGained(
          startTimestamp: start,
          endTimestamp: now,
          harmonized: const ElevationGainedHarmonized(elevation: 25),
        );
      case HealthType.exerciseSession:
        return ExerciseSession(
          startTimestamp: start,
          endTimestamp: now,
          harmonized: ExerciseSessionHarmonized(
            exerciseType: ExerciseType.running,
            title: 'Morning run',
            segments: [
              ExerciseSessionSegment(
                startTimestamp: start,
                endTimestamp: mid,
                segmentType: ExerciseSegmentType.running,
              ),
            ],
            laps: [
              ExerciseSessionLap(
                startTimestamp: start,
                endTimestamp: mid,
                length: 400,
              ),
            ],
            route: ExerciseSessionRoute(
              locations: [
                ExerciseSessionLocation(
                  timestamp: mid,
                  latitude: 52.52,
                  longitude: 13.405,
                ),
              ],
            ),
          ),
        );
      case HealthType.floorsClimbed:
        return FloorsClimbed(
          startTimestamp: start,
          endTimestamp: now,
          harmonized: const FloorsClimbedHarmonized(floors: 3),
        );
      case HealthType.heartRate:
        return HeartRate(
          startTimestamp: start,
          endTimestamp: now,
          harmonized: HeartRateHarmonized(
            series: [
              HeartRateSeries(timestamp: start, beatsPerMinute: 70),
              HeartRateSeries(timestamp: mid, beatsPerMinute: 90),
            ],
          ),
        );
      case HealthType.heartRateVariabilityRmssd:
        return HeartRateVariabilityRmssd(
          startTimestamp: now,
          harmonized: const HeartRateVariabilityRmssdHarmonized(
            heartRateVariabilityMillis: 45,
          ),
        );
      case HealthType.height:
        return Height(
          startTimestamp: now,
          harmonized: const HeightHarmonized(height: 1.8),
        );
      case HealthType.hydration:
        return Hydration(
          startTimestamp: start,
          endTimestamp: now,
          harmonized: const HydrationHarmonized(volume: 0.25),
        );
      case HealthType.intermenstrualBleeding:
        return IntermenstrualBleeding(startTimestamp: now);
      case HealthType.leanBodyMass:
        return LeanBodyMass(
          startTimestamp: now,
          harmonized: const LeanBodyMassHarmonized(mass: 60),
        );
      case HealthType.menstruationFlow:
        return MenstruationFlow(
          startTimestamp: now,
          harmonized: const MenstruationFlowHarmonized(
            flow: MenstruationFlowType.medium,
          ),
        );
      case HealthType.menstruationPeriod:
        return MenstruationPeriod(startTimestamp: start, endTimestamp: now);
      case HealthType.mindfulnessSession:
        return MindfulnessSession(
          startTimestamp: start,
          endTimestamp: now,
          harmonized: const MindfulnessSessionHarmonized(
            mindfulnessSessionType: MindfulnessSessionType.meditation,
            title: 'Calm',
          ),
        );
      case HealthType.nutrition:
        return Nutrition(
          startTimestamp: start,
          endTimestamp: now,
          harmonized: const NutritionHarmonized(
            energy: 95,
            sugar: 0.019,
            name: 'Apple',
            mealType: MealType.snack,
          ),
        );
      case HealthType.ovulationTest:
        return OvulationTest(
          startTimestamp: now,
          harmonized: const OvulationTestHarmonized(
            result: OvulationTestResult.negative,
          ),
        );
      case HealthType.oxygenSaturation:
        return OxygenSaturation(
          startTimestamp: now,
          harmonized: const OxygenSaturationHarmonized(percentage: 98),
        );
      case HealthType.plannedExerciseSession:
        return PlannedExerciseSession(
          startTimestamp: start,
          endTimestamp: now,
          harmonized: PlannedExerciseSessionHarmonized(
            exerciseType: ExerciseType.running,
            title: 'Intervals',
            blocks: [
              PlannedExerciseSessionBlock(
                repetitions: 2,
                steps: [
                  PlannedExerciseSessionStep(
                    exerciseType: ExerciseSegmentType.running,
                    exercisePhase: ExercisePhase.warmup,
                    completionGoal: const CompletionGoalDuration(
                      durationMillis: 600000,
                    ),
                    performanceTargets: const [
                      PerformanceTargetHeartRate(
                        minHeartRate: 100,
                        maxHeartRate: 120,
                      ),
                    ],
                  ),
                  PlannedExerciseSessionStep(
                    exerciseType: ExerciseSegmentType.running,
                    exercisePhase: ExercisePhase.active,
                    completionGoal: const CompletionGoalDistance(
                      distance: 1000,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      case HealthType.power:
        return Power(
          startTimestamp: start,
          endTimestamp: now,
          harmonized: PowerHarmonized(
            series: [PowerSeries(timestamp: mid, power: 250)],
          ),
        );
      case HealthType.respiratoryRate:
        return RespiratoryRate(
          startTimestamp: now,
          harmonized: const RespiratoryRateHarmonized(rate: 16),
        );
      case HealthType.restingHeartRate:
        return RestingHeartRate(
          startTimestamp: now,
          harmonized: const RestingHeartRateHarmonized(beatsPerMinute: 55),
        );
      case HealthType.sexualActivity:
        return SexualActivity(
          startTimestamp: now,
          harmonized: const SexualActivityHarmonized(
            protectionUsed: ProtectionUsed.protected,
          ),
        );
      case HealthType.skinTemperature:
        return SkinTemperature(
          startTimestamp: start,
          endTimestamp: now,
          harmonized: SkinTemperatureHarmonized(
            deltas: [SkinTemperatureDelta(timestamp: mid, delta: 0.5)],
            baseline: 33.5,
            measurementLocation: SkinTemperatureMeasurementLocation.wrist,
          ),
        );
      case HealthType.sleepSession:
        final night = now - const Duration(hours: 8).inMilliseconds;
        final deep = now - const Duration(hours: 4).inMilliseconds;
        return SleepSession(
          startTimestamp: night,
          endTimestamp: now,
          harmonized: SleepSessionHarmonized(
            title: 'Night',
            stages: [
              SleepSessionStage(
                startTimestamp: night,
                endTimestamp: deep,
                stage: SleepStageType.light,
              ),
              SleepSessionStage(
                startTimestamp: deep,
                endTimestamp: now,
                stage: SleepStageType.deep,
              ),
            ],
          ),
        );
      case HealthType.speed:
        return Speed(
          startTimestamp: start,
          endTimestamp: now,
          harmonized: SpeedHarmonized(
            series: [SpeedSeries(timestamp: mid, speed: 3.5)],
          ),
        );
      case HealthType.steps:
        return Steps(
          startTimestamp: start,
          endTimestamp: now,
          harmonized: const StepsHarmonized(count: 1200),
        );
      case HealthType.stepsCadence:
        return StepsCadence(
          startTimestamp: start,
          endTimestamp: now,
          harmonized: StepsCadenceHarmonized(
            series: [StepsCadenceSeries(timestamp: mid, rate: 160)],
          ),
        );
      case HealthType.totalCaloriesBurned:
        return TotalCaloriesBurned(
          startTimestamp: start,
          endTimestamp: now,
          harmonized: const TotalCaloriesBurnedHarmonized(energy: 300),
        );
      case HealthType.vo2Max:
        return Vo2Max(
          startTimestamp: now,
          harmonized: const Vo2MaxHarmonized(
            vo2MillilitersPerMinuteKilogram: 45,
            measurementMethod: Vo2MaxMeasurementMethod.cooperTest,
          ),
        );
      case HealthType.weight:
        return Weight(
          startTimestamp: now,
          harmonized: const WeightHarmonized(weight: 72.5),
        );
      case HealthType.wheelchairPushes:
        return WheelchairPushes(
          startTimestamp: start,
          endTimestamp: now,
          harmonized: const WheelchairPushesHarmonized(count: 50),
        );
    }
  }
}
