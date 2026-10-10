/// Reads a number of the JSON payload.
///
num parseNum(dynamic value) {
  if (value is num) return value;
  if (value is String) return double.parse(value);
  throw FormatException('Expected a number, got $value');
}

/// [parseNum] for optional fields.
///
num? tryParseNum(dynamic value) => value == null ? null : parseNum(value);
