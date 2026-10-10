// JSON payloads shaped like HealthConnectReporter 1.0.0 encodes them,
// copied from the library's test fixtures (`Fixtures.kt`) with the timestamps moved:
// a sample carries its `type` discriminator, null fields are left out,
// defaults are present, Kotlin Doubles are encoded with a fraction.

const start = 1760000000000;
const mid = 1760001800000;
const end = 1760003600000;
const offset = 7200;

const device = {
  'type': 'WATCH',
  'manufacturer': 'Google',
  'model': 'Pixel Watch',
};

const activeCaloriesBurned = {
  'type': 'active_calories_burned',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'energy': 120.5,
  },
  'clientRecordId': 'client-activeCaloriesBurned',
  'clientRecordVersion': 1,
  'recordingMethod': 'MANUAL_ENTRY',
};

const basalBodyTemperature = {
  'type': 'basal_body_temperature',
  'startTimestamp': start,
  'harmonized': {
    'temperature': 36.6,
    'measurementLocation': 'MOUTH',
  },
  'clientRecordId': 'client-basalBodyTemperature',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'recordingMethod': 'AUTOMATICALLY_RECORDED',
  'device': device,
};

const basalMetabolicRate = {
  'type': 'basal_metabolic_rate',
  'startTimestamp': start,
  'harmonized': {
    'basalMetabolicRate': 70.0,
  },
  'clientRecordId': 'client-basalMetabolicRate',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'recordingMethod': 'ACTIVELY_RECORDED',
  'device': device,
};

const bloodGlucose = {
  'type': 'blood_glucose',
  'startTimestamp': start,
  'harmonized': {
    'level': 5.5,
    'specimenSource': 'CAPILLARY_BLOOD',
    'mealType': 'BREAKFAST',
    'relationToMeal': 'AFTER_MEAL',
  },
  'clientRecordId': 'client-bloodGlucose',
  'clientRecordVersion': 1,
  'recordingMethod': 'UNKNOWN',
  'device': device,
};

const bloodPressure = {
  'type': 'blood_pressure',
  'startTimestamp': start,
  'harmonized': {
    'systolic': 120.0,
    'diastolic': 80.0,
    'bodyPosition': 'SITTING_DOWN',
    'measurementLocation': 'LEFT_UPPER_ARM',
  },
  'clientRecordId': 'client-bloodPressure',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'recordingMethod': 'MANUAL_ENTRY',
};

const bodyFat = {
  'type': 'body_fat',
  'startTimestamp': start,
  'harmonized': {
    'percentage': 18.5,
  },
  'clientRecordId': 'client-bodyFat',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'recordingMethod': 'AUTOMATICALLY_RECORDED',
  'device': device,
};

const bodyTemperature = {
  'type': 'body_temperature',
  'startTimestamp': start,
  'harmonized': {
    'temperature': 36.8,
    'measurementLocation': 'ARMPIT',
  },
  'clientRecordId': 'client-bodyTemperature',
  'clientRecordVersion': 1,
  'recordingMethod': 'ACTIVELY_RECORDED',
  'device': device,
};

const bodyWaterMass = {
  'type': 'body_water_mass',
  'startTimestamp': start,
  'harmonized': {
    'mass': 40.0,
  },
  'clientRecordId': 'client-bodyWaterMass',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'recordingMethod': 'UNKNOWN',
  'device': device,
};

const boneMass = {
  'type': 'bone_mass',
  'startTimestamp': start,
  'harmonized': {
    'mass': 3.2,
  },
  'clientRecordId': 'client-boneMass',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'recordingMethod': 'MANUAL_ENTRY',
};

const cervicalMucus = {
  'type': 'cervical_mucus',
  'startTimestamp': start,
  'harmonized': {
    'appearance': 'CREAMY',
    'sensation': 'MEDIUM',
  },
  'clientRecordId': 'client-cervicalMucus',
  'clientRecordVersion': 1,
  'recordingMethod': 'AUTOMATICALLY_RECORDED',
  'device': device,
};

const cyclingPedalingCadence = {
  'type': 'cycling_pedaling_cadence',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'series': [
      {
        'timestamp': mid,
        'revolutionsPerMinute': 80.0,
      },
    ],
  },
  'clientRecordId': 'client-cyclingPedalingCadence',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'endZoneOffsetSeconds': offset,
  'recordingMethod': 'ACTIVELY_RECORDED',
  'device': device,
};

const distance = {
  'type': 'distance',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'distance': 1500.0,
  },
  'clientRecordId': 'client-distance',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'endZoneOffsetSeconds': offset,
  'recordingMethod': 'UNKNOWN',
  'device': device,
};

const elevationGained = {
  'type': 'elevation_gained',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'elevation': 25.0,
  },
  'clientRecordId': 'client-elevationGained',
  'clientRecordVersion': 1,
  'recordingMethod': 'MANUAL_ENTRY',
};

const exerciseSession = {
  'type': 'exercise',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'exerciseType': 'RUNNING',
    'title': 'Morning run',
    'notes': 'Easy',
    'segments': [
      {
        'startTimestamp': start,
        'endTimestamp': mid,
        'segmentType': 'RUNNING',
        'repetitions': 0,
      },
    ],
    'laps': [
      {
        'startTimestamp': start,
        'endTimestamp': mid,
        'length': 400.0,
      },
    ],
    'route': {
      'locations': [
        {
          'timestamp': mid,
          'latitude': 52.52,
          'longitude': 13.405,
          'horizontalAccuracy': 5.0,
          'verticalAccuracy': 3.0,
          'altitude': 34.0,
        },
      ],
    },
    'isRouteConsentRequired': false,
    'plannedExerciseSessionId': 'planned-1',
  },
  'clientRecordId': 'client-exerciseSession',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'endZoneOffsetSeconds': offset,
  'recordingMethod': 'AUTOMATICALLY_RECORDED',
  'device': device,
};

const floorsClimbed = {
  'type': 'floors_climbed',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'floors': 3.0,
  },
  'clientRecordId': 'client-floorsClimbed',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'endZoneOffsetSeconds': offset,
  'recordingMethod': 'ACTIVELY_RECORDED',
  'device': device,
};

const heartRate = {
  'type': 'heart_rate',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'series': [
      {
        'timestamp': start,
        'beatsPerMinute': 70,
      },
      {
        'timestamp': mid,
        'beatsPerMinute': 90,
      },
    ],
  },
  'clientRecordId': 'client-heartRate',
  'clientRecordVersion': 1,
  'recordingMethod': 'UNKNOWN',
  'device': device,
};

const heartRateVariabilityRmssd = {
  'type': 'heart_rate_variability_rmssd',
  'startTimestamp': start,
  'harmonized': {
    'heartRateVariabilityMillis': 45.0,
  },
  'clientRecordId': 'client-heartRateVariabilityRmssd',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'recordingMethod': 'MANUAL_ENTRY',
};

const height = {
  'type': 'height',
  'startTimestamp': start,
  'harmonized': {
    'height': 1.8,
  },
  'clientRecordId': 'client-height',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'recordingMethod': 'AUTOMATICALLY_RECORDED',
  'device': device,
};

const hydration = {
  'type': 'water_intake',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'volume': 0.5,
  },
  'clientRecordId': 'client-hydration',
  'clientRecordVersion': 1,
  'recordingMethod': 'ACTIVELY_RECORDED',
  'device': device,
};

const intermenstrualBleeding = {
  'type': 'intermenstrual_bleeding',
  'startTimestamp': start,
  'clientRecordId': 'client-intermenstrualBleeding',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'recordingMethod': 'UNKNOWN',
  'device': device,
};

const leanBodyMass = {
  'type': 'lean_body_mass',
  'startTimestamp': start,
  'harmonized': {
    'mass': 60.0,
  },
  'clientRecordId': 'client-leanBodyMass',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'recordingMethod': 'MANUAL_ENTRY',
};

const menstruationFlow = {
  'type': 'menstruation_flow',
  'startTimestamp': start,
  'harmonized': {
    'flow': 'MEDIUM',
  },
  'clientRecordId': 'client-menstruationFlow',
  'clientRecordVersion': 1,
  'recordingMethod': 'AUTOMATICALLY_RECORDED',
  'device': device,
};

const menstruationPeriod = {
  'type': 'menstruation_period',
  'startTimestamp': start,
  'endTimestamp': end,
  'clientRecordId': 'client-menstruationPeriod',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'endZoneOffsetSeconds': offset,
  'recordingMethod': 'ACTIVELY_RECORDED',
  'device': device,
};

const mindfulnessSession = {
  'type': 'mindfulness_session',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'mindfulnessSessionType': 'MEDITATION',
    'title': 'Calm',
    'notes': 'Breathe',
  },
  'clientRecordId': 'client-mindfulnessSession',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'endZoneOffsetSeconds': offset,
  'recordingMethod': 'UNKNOWN',
  'device': device,
};

const nutrition = {
  'type': 'nutrition',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'biotin': 1.0E-5,
    'caffeine': 2.0E-5,
    'calcium': 3.0E-5,
    'energy': 500.0,
    'energyFromFat': 90.0,
    'chloride': 6.0E-5,
    'cholesterol': 7.0E-5,
    'chromium': 8.0E-5,
    'copper': 9.0E-5,
    'dietaryFiber': 1.0E-4,
    'folate': 1.1E-4,
    'folicAcid': 1.2E-4,
    'iodine': 1.3E-4,
    'iron': 1.4E-4,
    'magnesium': 1.5E-4,
    'manganese': 1.6E-4,
    'molybdenum': 1.7E-4,
    'monounsaturatedFat': 1.8E-4,
    'niacin': 1.9E-4,
    'pantothenicAcid': 2.0E-4,
    'phosphorus': 2.1E-4,
    'polyunsaturatedFat': 2.2E-4,
    'potassium': 2.3E-4,
    'protein': 2.4E-4,
    'riboflavin': 2.5E-4,
    'saturatedFat': 2.6E-4,
    'selenium': 2.7E-4,
    'sodium': 2.8E-4,
    'sugar': 2.9E-4,
    'thiamin': 3.0E-4,
    'totalCarbohydrate': 3.1E-4,
    'totalFat': 3.2E-4,
    'transFat': 3.3E-4,
    'unsaturatedFat': 3.4E-4,
    'vitaminA': 3.5E-4,
    'vitaminB12': 3.6E-4,
    'vitaminB6': 3.7E-4,
    'vitaminC': 3.8E-4,
    'vitaminD': 3.9E-4,
    'vitaminE': 4.0E-4,
    'vitaminK': 4.1E-4,
    'zinc': 4.2E-4,
    'name': 'Lunch',
    'mealType': 'LUNCH',
  },
  'clientRecordId': 'client-nutrition',
  'clientRecordVersion': 1,
  'recordingMethod': 'MANUAL_ENTRY',
};

const ovulationTest = {
  'type': 'ovulation_test',
  'startTimestamp': start,
  'harmonized': {
    'result': 'POSITIVE',
  },
  'clientRecordId': 'client-ovulationTest',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'recordingMethod': 'AUTOMATICALLY_RECORDED',
  'device': device,
};

const oxygenSaturation = {
  'type': 'blood_oxygen',
  'startTimestamp': start,
  'harmonized': {
    'percentage': 98.0,
  },
  'clientRecordId': 'client-oxygenSaturation',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'recordingMethod': 'ACTIVELY_RECORDED',
  'device': device,
};

const plannedExerciseSession = {
  'type': 'planned_exercise',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'exerciseType': 'RUNNING',
    'blocks': [
      {
        'repetitions': 2,
        'steps': [
          {
            'exerciseType': 'RUNNING',
            'exercisePhase': 'WARMUP',
            'completionGoal': {
              'type': 'duration',
              'durationMillis': 600000,
            },
            'performanceTargets': [
              {
                'type': 'heart_rate',
                'minHeartRate': 100.0,
                'maxHeartRate': 120.0,
              },
            ],
            'description': 'Warm up',
          },
          {
            'exerciseType': 'RUNNING',
            'exercisePhase': 'ACTIVE',
            'completionGoal': {
              'type': 'distance',
              'distance': 1000.0,
            },
            'performanceTargets': <dynamic>[],
          },
        ],
        'description': 'Intervals',
      },
    ],
    'title': 'Intervals',
    'notes': 'Twice',
    'hasExplicitTime': true,
  },
  'clientRecordId': 'client-plannedExerciseSession',
  'clientRecordVersion': 1,
  'recordingMethod': 'UNKNOWN',
  'device': device,
};

const power = {
  'type': 'power',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'series': [
      {
        'timestamp': mid,
        'power': 250.0,
      },
    ],
  },
  'clientRecordId': 'client-power',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'endZoneOffsetSeconds': offset,
  'recordingMethod': 'MANUAL_ENTRY',
};

const respiratoryRate = {
  'type': 'respiratory_rate',
  'startTimestamp': start,
  'harmonized': {
    'rate': 16.0,
  },
  'clientRecordId': 'client-respiratoryRate',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'recordingMethod': 'AUTOMATICALLY_RECORDED',
  'device': device,
};

const restingHeartRate = {
  'type': 'resting_heart_rate',
  'startTimestamp': start,
  'harmonized': {
    'beatsPerMinute': 55,
  },
  'clientRecordId': 'client-restingHeartRate',
  'clientRecordVersion': 1,
  'recordingMethod': 'ACTIVELY_RECORDED',
  'device': device,
};

const sexualActivity = {
  'type': 'sexual_activity',
  'startTimestamp': start,
  'harmonized': {
    'protectionUsed': 'PROTECTED',
  },
  'clientRecordId': 'client-sexualActivity',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'recordingMethod': 'UNKNOWN',
  'device': device,
};

const skinTemperature = {
  'type': 'skin_temperature',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'deltas': [
      {
        'timestamp': mid,
        'delta': 0.5,
      },
    ],
    'baseline': 33.5,
    'measurementLocation': 'WRIST',
  },
  'clientRecordId': 'client-skinTemperature',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'endZoneOffsetSeconds': offset,
  'recordingMethod': 'MANUAL_ENTRY',
};

const sleepSession = {
  'type': 'sleep',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'title': 'Night',
    'notes': 'Restful',
    'stages': [
      {
        'startTimestamp': start,
        'endTimestamp': mid,
        'stage': 'LIGHT',
      },
      {
        'startTimestamp': mid,
        'endTimestamp': end,
        'stage': 'DEEP',
      },
    ],
  },
  'clientRecordId': 'client-sleepSession',
  'clientRecordVersion': 1,
  'recordingMethod': 'AUTOMATICALLY_RECORDED',
  'device': device,
};

const speed = {
  'type': 'speed',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'series': [
      {
        'timestamp': mid,
        'speed': 3.5,
      },
    ],
  },
  'clientRecordId': 'client-speed',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'endZoneOffsetSeconds': offset,
  'recordingMethod': 'ACTIVELY_RECORDED',
  'device': device,
};

const steps = {
  'type': 'steps',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'count': 1200,
  },
  'clientRecordId': 'client-steps',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'endZoneOffsetSeconds': offset,
  'recordingMethod': 'UNKNOWN',
  'device': device,
};

const stepsCadence = {
  'type': 'steps_cadence',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'series': [
      {
        'timestamp': mid,
        'rate': 160.0,
      },
    ],
  },
  'clientRecordId': 'client-stepsCadence',
  'clientRecordVersion': 1,
  'recordingMethod': 'MANUAL_ENTRY',
};

const totalCaloriesBurned = {
  'type': 'total_calories_burned',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'energy': 300.0,
  },
  'clientRecordId': 'client-totalCaloriesBurned',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'endZoneOffsetSeconds': offset,
  'recordingMethod': 'AUTOMATICALLY_RECORDED',
  'device': device,
};

const vo2Max = {
  'type': 'vo2_max',
  'startTimestamp': start,
  'harmonized': {
    'vo2MillilitersPerMinuteKilogram': 45.0,
    'measurementMethod': 'COOPER_TEST',
  },
  'clientRecordId': 'client-vo2Max',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'recordingMethod': 'ACTIVELY_RECORDED',
  'device': device,
};

const weight = {
  'type': 'weight',
  'startTimestamp': start,
  'harmonized': {
    'weight': 72.5,
  },
  'clientRecordId': 'client-weight',
  'clientRecordVersion': 1,
  'recordingMethod': 'UNKNOWN',
  'device': device,
};

const wheelchairPushes = {
  'type': 'wheelchair_pushes',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'count': 50,
  },
  'clientRecordId': 'client-wheelchairPushes',
  'clientRecordVersion': 1,
  'startZoneOffsetSeconds': offset,
  'endZoneOffsetSeconds': offset,
  'recordingMethod': 'MANUAL_ENTRY',
};

const stepsMetadata = {
  'type': 'steps',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'count': 1200,
  },
  'id': 'id-1',
  'clientRecordId': 'client-1',
  'clientRecordVersion': 2,
  'startZoneOffsetSeconds': offset,
  'endZoneOffsetSeconds': offset,
  'recordingMethod': 'ACTIVELY_RECORDED',
  'device': device,
  'dataOrigin': {
    'packageName': 'com.example',
  },
  'lastModifiedTimestamp': end,
};

const dataOrigin = {
  'packageName': 'com.example',
};

const timeRange = {
  'startTimestamp': start,
  'endTimestamp': end,
};

const page = {
  'items': [
    {
      'type': 'steps',
      'startTimestamp': start,
      'endTimestamp': end,
      'harmonized': {
        'count': 1200,
      },
      'clientRecordId': 'client-steps',
      'clientRecordVersion': 1,
      'startZoneOffsetSeconds': offset,
      'endZoneOffsetSeconds': offset,
      'recordingMethod': 'UNKNOWN',
      'device': device,
    },
  ],
  'nextPageToken': 'next',
};

const aggregate = {
  'aggregation': 'STEPS_COUNT_TOTAL',
  'startTimestamp': start,
  'endTimestamp': end,
  'value': 1.0,
  'unit': 'count',
};

const aggregateEmpty = {
  'aggregation': 'STEPS_COUNT_TOTAL',
  'startTimestamp': start,
  'endTimestamp': end,
  'unit': 'count',
};

const anchor = {
  'token': 'token',
};

const changeSet = {
  'upserted': [
    {
      'type': 'steps',
      'startTimestamp': start,
      'endTimestamp': end,
      'harmonized': {
        'count': 1200,
      },
      'clientRecordId': 'client-steps',
      'clientRecordVersion': 1,
      'startZoneOffsetSeconds': offset,
      'endZoneOffsetSeconds': offset,
      'recordingMethod': 'UNKNOWN',
      'device': device,
    },
  ],
  'deletedIds': [
    'id-2',
  ],
  'anchor': {
    'token': 'token',
  },
};

const completionGoals = [
  {
    'type': 'distance',
    'distance': 1.0,
  },
  {
    'type': 'distance_and_duration',
    'distance': 1.0,
    'durationMillis': 1,
  },
  {
    'type': 'steps',
    'steps': 1,
  },
  {
    'type': 'duration',
    'durationMillis': 1,
  },
  {
    'type': 'repetitions',
    'repetitions': 1,
  },
  {
    'type': 'total_calories_burned',
    'totalCalories': 1.0,
  },
  {
    'type': 'active_calories_burned',
    'activeCalories': 1.0,
  },
  {
    'type': 'manual_completion',
  },
  {
    'type': 'unknown',
  },
];

const performanceTargets = [
  {
    'type': 'power',
    'minPower': 1.0,
    'maxPower': 2.0,
  },
  {
    'type': 'speed',
    'minSpeed': 1.0,
    'maxSpeed': 2.0,
  },
  {
    'type': 'cadence',
    'minCadence': 1.0,
    'maxCadence': 2.0,
  },
  {
    'type': 'heart_rate',
    'minHeartRate': 1.0,
    'maxHeartRate': 2.0,
  },
  {
    'type': 'weight',
    'mass': 1.0,
  },
  {
    'type': 'rate_of_perceived_exertion',
    'rpe': 1,
  },
  {
    'type': 'amrap',
  },
  {
    'type': 'unknown',
  },
];

const timeGroups = [
  {
    'type': 'duration',
    'durationMillis': 900000,
  },
  {
    'type': 'period',
    'unit': 'DAILY',
    'count': 2,
    'zoneId': 'Europe/Berlin',
  },
];

const permissions = [
  {
    'type': 'data',
    'healthType': 'STEPS',
    'access': 'READ',
  },
  {
    'type': 'read_in_background',
  },
  {
    'type': 'read_history',
  },
  {
    'type': 'write_exercise_route',
  },
];

/// Every sample fixture by its `type` discriminator
const samples = <String, Map<String, dynamic>>{
  'active_calories_burned': activeCaloriesBurned,
  'basal_body_temperature': basalBodyTemperature,
  'basal_metabolic_rate': basalMetabolicRate,
  'blood_glucose': bloodGlucose,
  'blood_pressure': bloodPressure,
  'body_fat': bodyFat,
  'body_temperature': bodyTemperature,
  'body_water_mass': bodyWaterMass,
  'bone_mass': boneMass,
  'cervical_mucus': cervicalMucus,
  'cycling_pedaling_cadence': cyclingPedalingCadence,
  'distance': distance,
  'elevation_gained': elevationGained,
  'exercise': exerciseSession,
  'floors_climbed': floorsClimbed,
  'heart_rate': heartRate,
  'heart_rate_variability_rmssd': heartRateVariabilityRmssd,
  'height': height,
  'water_intake': hydration,
  'intermenstrual_bleeding': intermenstrualBleeding,
  'lean_body_mass': leanBodyMass,
  'menstruation_flow': menstruationFlow,
  'menstruation_period': menstruationPeriod,
  'mindfulness_session': mindfulnessSession,
  'nutrition': nutrition,
  'ovulation_test': ovulationTest,
  'blood_oxygen': oxygenSaturation,
  'planned_exercise': plannedExerciseSession,
  'power': power,
  'respiratory_rate': respiratoryRate,
  'resting_heart_rate': restingHeartRate,
  'sexual_activity': sexualActivity,
  'skin_temperature': skinTemperature,
  'sleep': sleepSession,
  'speed': speed,
  'steps': steps,
  'steps_cadence': stepsCadence,
  'total_calories_burned': totalCaloriesBurned,
  'vo2_max': vo2Max,
  'weight': weight,
  'wheelchair_pushes': wheelchairPushes,
};

/// [map] without its null values, as the library encodes it
Map<String, dynamic> withoutNulls(Map<String, dynamic> map) => {
      for (final entry in map.entries)
        if (entry.value != null) entry.key: _withoutNulls(entry.value),
    };

dynamic _withoutNulls(dynamic value) {
  if (value is Map<String, dynamic>) return withoutNulls(value);
  if (value is List) return value.map(_withoutNulls).toList();
  return value;
}
