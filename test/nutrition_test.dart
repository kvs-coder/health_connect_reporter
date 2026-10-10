import 'package:flutter_test/flutter_test.dart';
import 'package:health_connect_reporter/model/payload/blood_glucose.dart';
import 'package:health_connect_reporter/model/payload/nutrition.dart';
import 'package:health_connect_reporter/model/type/meal_type.dart';
import 'package:health_connect_reporter/model/type/relation_to_meal.dart';
import 'package:health_connect_reporter/model/type/specimen_source.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('nutrition_parses_masses_in_kg_and_energy_in_kcal', () {
    final sut = Nutrition.fromJson(fixtures.nutrition).harmonized;
    expect(sut.biotin, 1.0E-5);
    expect(sut.energy, 500.0);
    expect(sut.energyFromFat, 90.0);
    expect(sut.zinc, 4.2E-4);
    expect(sut.name, 'Lunch');
    expect(sut.mealType, MealType.lunch);
  });

  test('nutrition_without_nutrients_parses_with_an_unknown_meal', () {
    final sut = NutritionHarmonized.fromJson(const {});
    expect(sut, const NutritionHarmonized());
    expect(sut.mealType, MealType.unknown);
    expect(fixtures.withoutNulls(sut.map), {'mealType': 'UNKNOWN'});
  });

  test('enum_defaults_are_sent_as_the_library_writes_them', () {
    const sut = BloodGlucoseHarmonized(level: 5.5);
    expect(sut.map, {
      'level': 5.5,
      'specimenSource': 'UNKNOWN',
      'mealType': 'UNKNOWN',
      'relationToMeal': 'UNKNOWN',
    });
    expect(BloodGlucoseHarmonized.fromJson(const {'level': 5.5}), sut);
    expect(sut.specimenSource, SpecimenSource.unknown);
    expect(sut.relationToMeal, RelationToMeal.unknown);
  });
}
