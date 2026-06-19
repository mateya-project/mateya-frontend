const Duration kKoreaUtcOffset = Duration(hours: 9);

DateTime mateyaNowInKst() => _shiftUtcInstantToKst(DateTime.now().toUtc());

DateTime parseServerDateTime(String value) {
  return _shiftUtcInstantToKst(DateTime.parse(value));
}

DateTime? tryParseServerDateTime(Object? value) {
  final normalized = switch (value) {
    null => null,
    String stringValue =>
      stringValue.trim().isEmpty ? null : stringValue.trim(),
    _ => '$value',
  };
  if (normalized == null) {
    return null;
  }

  final parsed = DateTime.tryParse(normalized);
  if (parsed == null) {
    return null;
  }
  return _shiftUtcInstantToKst(parsed);
}

DateTime _shiftUtcInstantToKst(DateTime value) {
  return value.toUtc().add(kKoreaUtcOffset);
}
