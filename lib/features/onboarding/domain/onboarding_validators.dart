class OnboardingValidators {
  static final RegExp _digitsOnly = RegExp(r'^\d+$');
  static final RegExp _asciiPunctuation = RegExp(
    r'[\u0021-\u002F\u003A-\u0040\u005B-\u0060\u007B-\u007E]',
  );

  static String? validateName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return '이름을 입력해 주세요.';
    }
    if (trimmed.runes.length > 30) {
      return '이름은 30자 이내로 입력해 주세요.';
    }
    if (_containsDisallowedNameCharacter(trimmed)) {
      return '숫자와 특수문자 없이 이름만 입력해 주세요.';
    }
    return null;
  }

  static String? validatePhoneNumber(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return '전화번호를 입력해 주세요.';
    }
    if (!_digitsOnly.hasMatch(digits)) {
      return '전화번호는 숫자만 입력해 주세요.';
    }
    if (digits.length > 15) {
      return '전화번호는 최대 15자리까지 입력할 수 있어요.';
    }
    if (digits.length < 9) {
      return '전화번호를 정확히 입력해 주세요.';
    }
    return null;
  }

  static String? validateVerificationCode(
    String input,
    String? expectedCode,
    bool isExpired,
  ) {
    if (input.length != 6) {
      return '인증번호 6자리를 입력해 주세요.';
    }
    if (isExpired) {
      return '인증 시간이 만료됐어요. 인증번호를 다시 받아 주세요.';
    }
    if (expectedCode != null && input != expectedCode) {
      return '인증번호가 일치하지 않아요.';
    }
    return null;
  }

  static String? validateBusinessName(String value) {
    if (value.trim().isEmpty) {
      return '상호명을 입력해 주세요.';
    }
    return null;
  }

  static String? validateBusinessOwner(String value) {
    return validateName(value);
  }

  static String? validateBusinessOpeningDate(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 8) {
      return '개업일자 8자리를 입력해 주세요.';
    }
    final year = int.tryParse(digits.substring(0, 4));
    final month = int.tryParse(digits.substring(4, 6));
    final day = int.tryParse(digits.substring(6, 8));
    if (year == null || month == null || day == null) {
      return '개업일자는 숫자만 입력해 주세요.';
    }
    try {
      final parsed = DateTime(year, month, day);
      if (parsed.year != year || parsed.month != month || parsed.day != day) {
        return '개업일자를 정확히 입력해 주세요.';
      }
    } catch (_) {
      return '개업일자를 정확히 입력해 주세요.';
    }
    return null;
  }

  static String? validateBusinessNumber(
    String first,
    String second,
    String third,
  ) {
    if (first.length != 3 || second.length != 2 || third.length != 5) {
      return '사업자 번호 10자리를 정확히 입력해 주세요.';
    }
    if (!(_digitsOnly.hasMatch(first) &&
        _digitsOnly.hasMatch(second) &&
        _digitsOnly.hasMatch(third))) {
      return '사업자 번호는 숫자만 입력해 주세요.';
    }
    return null;
  }

  static bool _containsDisallowedNameCharacter(String value) {
    for (final rune in value.runes) {
      final character = String.fromCharCode(rune);
      if (character.trim().isEmpty) {
        continue;
      }
      if (_digitsOnly.hasMatch(character) ||
          _asciiPunctuation.hasMatch(character)) {
        return true;
      }
    }
    return false;
  }
}
