import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/meal_type.dart';
import '../type/relation_to_meal.dart';
import '../type/specimen_source.dart';
import 'sample.dart';

/// Equivalent of [BloodGlucose]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// A blood glucose measurement, in mmol/L.
/// A single measurement at [startTimestamp].
///
/// Supports [map] representation.
///
/// Has a [BloodGlucose.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.bloodGlucose] permissions provided.
///
class BloodGlucose extends WritableSample<BloodGlucoseHarmonized> {
  const BloodGlucose({
    required super.startTimestamp,
    this.endTimestamp,
    required super.harmonized,
    super.id,
    super.clientRecordId,
    super.clientRecordVersion,
    super.startZoneOffsetSeconds,
    super.endZoneOffsetSeconds,
    super.recordingMethod,
    super.device,
    super.dataOrigin,
    super.lastModifiedTimestamp,
  });

  /// Not used: the record is a single measurement at [startTimestamp]
  @override
  final int? endTimestamp;

  @override
  HealthType get healthType => HealthType.bloodGlucose;

  /// General constructor from JSON payload
  ///
  BloodGlucose.fromJson(Map<String, dynamic> json)
      : endTimestamp = tryParseInt(json['endTimestamp']),
        super.from(json,
            BloodGlucoseHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<BloodGlucose> collect(List<dynamic> list) =>
      parseObjects(list, BloodGlucose.fromJson);
}

/// Equivalent of [BloodGlucose.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of BloodGlucose.
///
/// Supports [map] representation.
///
/// Has a [BloodGlucoseHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class BloodGlucoseHarmonized with Payload {
  const BloodGlucoseHarmonized({
    required this.level,
    this.specimenSource = SpecimenSource.unknown,
    this.mealType = MealType.unknown,
    this.relationToMeal = RelationToMeal.unknown,
  });

  /// Blood glucose level in mmol/L (0–50)
  final double level;

  /// The measured specimen. [SpecimenSource.unknown] by default
  final SpecimenSource specimenSource;

  /// The meal the measurement relates to. [MealType.unknown] by default
  final MealType mealType;

  /// When the measurement was taken relative to the meal.
  /// [RelationToMeal.unknown] by default
  final RelationToMeal relationToMeal;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'level': level,
        'specimenSource': specimenSource.value,
        'mealType': mealType.value,
        'relationToMeal': relationToMeal.value,
      };

  /// General constructor from JSON payload
  ///
  BloodGlucoseHarmonized.fromJson(Map<String, dynamic> json)
      : level = parseDouble(json['level']),
        specimenSource = json['specimenSource'] == null
            ? SpecimenSource.unknown
            : SpecimenSource.from(json['specimenSource']),
        mealType = json['mealType'] == null
            ? MealType.unknown
            : MealType.from(json['mealType']),
        relationToMeal = json['relationToMeal'] == null
            ? RelationToMeal.unknown
            : RelationToMeal.from(json['relationToMeal']);
}
