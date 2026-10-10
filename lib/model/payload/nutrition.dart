import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/health_type.dart';
import '../type/meal_type.dart';
import 'sample.dart';

/// Equivalent of [Nutrition]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// Nutrients of a meal or food; masses in kg, energy in kcal.
///
/// Supports [map] representation.
///
/// Has a [Nutrition.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [HealthType.nutrition] permissions provided.
///
class Nutrition extends WritableSample<NutritionHarmonized> {
  const Nutrition({
    required super.startTimestamp,
    required this.endTimestamp,
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

  /// End time, epoch milliseconds, not before [startTimestamp]
  @override
  final int endTimestamp;

  @override
  HealthType get healthType => HealthType.nutrition;

  /// General constructor from JSON payload
  ///
  Nutrition.fromJson(Map<String, dynamic> json)
      : endTimestamp = parseInt(json['endTimestamp']),
        super.from(json,
            NutritionHarmonized.fromJson(parseObject(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Nutrition> collect(List<dynamic> list) =>
      parseObjects(list, Nutrition.fromJson);
}

/// Equivalent of [Nutrition.Harmonized]
/// from [HealthConnectReporter] https://github.com/kvs-coder/HealthConnectReporter
///
/// The values of Nutrition.
///
/// Supports [map] representation.
///
/// Has a [NutritionHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class NutritionHarmonized with Payload {
  const NutritionHarmonized({
    this.biotin,
    this.caffeine,
    this.calcium,
    this.energy,
    this.energyFromFat,
    this.chloride,
    this.cholesterol,
    this.chromium,
    this.copper,
    this.dietaryFiber,
    this.folate,
    this.folicAcid,
    this.iodine,
    this.iron,
    this.magnesium,
    this.manganese,
    this.molybdenum,
    this.monounsaturatedFat,
    this.niacin,
    this.pantothenicAcid,
    this.phosphorus,
    this.polyunsaturatedFat,
    this.potassium,
    this.protein,
    this.riboflavin,
    this.saturatedFat,
    this.selenium,
    this.sodium,
    this.sugar,
    this.thiamin,
    this.totalCarbohydrate,
    this.totalFat,
    this.transFat,
    this.unsaturatedFat,
    this.vitaminA,
    this.vitaminB12,
    this.vitaminB6,
    this.vitaminC,
    this.vitaminD,
    this.vitaminE,
    this.vitaminK,
    this.zinc,
    this.name,
    this.mealType = MealType.unknown,
  });

  /// Biotin in kg
  final double? biotin;

  /// Caffeine in kg
  final double? caffeine;

  /// Calcium in kg
  final double? calcium;

  /// Energy in kcal
  final double? energy;

  /// Energy from fat in kcal
  final double? energyFromFat;

  /// Chloride in kg
  final double? chloride;

  /// Cholesterol in kg
  final double? cholesterol;

  /// Chromium in kg
  final double? chromium;

  /// Copper in kg
  final double? copper;

  /// Dietary fiber in kg
  final double? dietaryFiber;

  /// Folate in kg
  final double? folate;

  /// Folic acid in kg
  final double? folicAcid;

  /// Iodine in kg
  final double? iodine;

  /// Iron in kg
  final double? iron;

  /// Magnesium in kg
  final double? magnesium;

  /// Manganese in kg
  final double? manganese;

  /// Molybdenum in kg
  final double? molybdenum;

  /// Monounsaturated fat in kg
  final double? monounsaturatedFat;

  /// Niacin in kg
  final double? niacin;

  /// Pantothenic acid in kg
  final double? pantothenicAcid;

  /// Phosphorus in kg
  final double? phosphorus;

  /// Polyunsaturated fat in kg
  final double? polyunsaturatedFat;

  /// Potassium in kg
  final double? potassium;

  /// Protein in kg
  final double? protein;

  /// Riboflavin in kg
  final double? riboflavin;

  /// Saturated fat in kg
  final double? saturatedFat;

  /// Selenium in kg
  final double? selenium;

  /// Sodium in kg
  final double? sodium;

  /// Sugar in kg
  final double? sugar;

  /// Thiamin in kg
  final double? thiamin;

  /// Total carbohydrate in kg
  final double? totalCarbohydrate;

  /// Total fat in kg
  final double? totalFat;

  /// Trans fat in kg
  final double? transFat;

  /// Unsaturated fat in kg
  final double? unsaturatedFat;

  /// Vitamin A in kg
  final double? vitaminA;

  /// Vitamin B12 in kg
  final double? vitaminB12;

  /// Vitamin B6 in kg
  final double? vitaminB6;

  /// Vitamin C in kg
  final double? vitaminC;

  /// Vitamin D in kg
  final double? vitaminD;

  /// Vitamin E in kg
  final double? vitaminE;

  /// Vitamin K in kg
  final double? vitaminK;

  /// Zinc in kg
  final double? zinc;

  /// The name of the food or meal
  final String? name;

  /// The meal. [MealType.unknown] by default
  final MealType mealType;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'biotin': biotin,
        'caffeine': caffeine,
        'calcium': calcium,
        'energy': energy,
        'energyFromFat': energyFromFat,
        'chloride': chloride,
        'cholesterol': cholesterol,
        'chromium': chromium,
        'copper': copper,
        'dietaryFiber': dietaryFiber,
        'folate': folate,
        'folicAcid': folicAcid,
        'iodine': iodine,
        'iron': iron,
        'magnesium': magnesium,
        'manganese': manganese,
        'molybdenum': molybdenum,
        'monounsaturatedFat': monounsaturatedFat,
        'niacin': niacin,
        'pantothenicAcid': pantothenicAcid,
        'phosphorus': phosphorus,
        'polyunsaturatedFat': polyunsaturatedFat,
        'potassium': potassium,
        'protein': protein,
        'riboflavin': riboflavin,
        'saturatedFat': saturatedFat,
        'selenium': selenium,
        'sodium': sodium,
        'sugar': sugar,
        'thiamin': thiamin,
        'totalCarbohydrate': totalCarbohydrate,
        'totalFat': totalFat,
        'transFat': transFat,
        'unsaturatedFat': unsaturatedFat,
        'vitaminA': vitaminA,
        'vitaminB12': vitaminB12,
        'vitaminB6': vitaminB6,
        'vitaminC': vitaminC,
        'vitaminD': vitaminD,
        'vitaminE': vitaminE,
        'vitaminK': vitaminK,
        'zinc': zinc,
        'name': name,
        'mealType': mealType.value,
      };

  /// General constructor from JSON payload
  ///
  NutritionHarmonized.fromJson(Map<String, dynamic> json)
      : biotin = tryParseDouble(json['biotin']),
        caffeine = tryParseDouble(json['caffeine']),
        calcium = tryParseDouble(json['calcium']),
        energy = tryParseDouble(json['energy']),
        energyFromFat = tryParseDouble(json['energyFromFat']),
        chloride = tryParseDouble(json['chloride']),
        cholesterol = tryParseDouble(json['cholesterol']),
        chromium = tryParseDouble(json['chromium']),
        copper = tryParseDouble(json['copper']),
        dietaryFiber = tryParseDouble(json['dietaryFiber']),
        folate = tryParseDouble(json['folate']),
        folicAcid = tryParseDouble(json['folicAcid']),
        iodine = tryParseDouble(json['iodine']),
        iron = tryParseDouble(json['iron']),
        magnesium = tryParseDouble(json['magnesium']),
        manganese = tryParseDouble(json['manganese']),
        molybdenum = tryParseDouble(json['molybdenum']),
        monounsaturatedFat = tryParseDouble(json['monounsaturatedFat']),
        niacin = tryParseDouble(json['niacin']),
        pantothenicAcid = tryParseDouble(json['pantothenicAcid']),
        phosphorus = tryParseDouble(json['phosphorus']),
        polyunsaturatedFat = tryParseDouble(json['polyunsaturatedFat']),
        potassium = tryParseDouble(json['potassium']),
        protein = tryParseDouble(json['protein']),
        riboflavin = tryParseDouble(json['riboflavin']),
        saturatedFat = tryParseDouble(json['saturatedFat']),
        selenium = tryParseDouble(json['selenium']),
        sodium = tryParseDouble(json['sodium']),
        sugar = tryParseDouble(json['sugar']),
        thiamin = tryParseDouble(json['thiamin']),
        totalCarbohydrate = tryParseDouble(json['totalCarbohydrate']),
        totalFat = tryParseDouble(json['totalFat']),
        transFat = tryParseDouble(json['transFat']),
        unsaturatedFat = tryParseDouble(json['unsaturatedFat']),
        vitaminA = tryParseDouble(json['vitaminA']),
        vitaminB12 = tryParseDouble(json['vitaminB12']),
        vitaminB6 = tryParseDouble(json['vitaminB6']),
        vitaminC = tryParseDouble(json['vitaminC']),
        vitaminD = tryParseDouble(json['vitaminD']),
        vitaminE = tryParseDouble(json['vitaminE']),
        vitaminK = tryParseDouble(json['vitaminK']),
        zinc = tryParseDouble(json['zinc']),
        name = json['name'],
        mealType = json['mealType'] == null
            ? MealType.unknown
            : MealType.from(json['mealType']);
}
