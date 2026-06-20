import '../../../shared/localization/mateya_localizations.dart';

class OnboardingValidators {
  static final RegExp _digitsOnly = RegExp(r'^\d+$');
  static final RegExp _asciiPunctuation = RegExp(
    r'[\u0021-\u002F\u003A-\u0040\u005B-\u0060\u007B-\u007E]',
  );

  static String? validateName(String value) {
    final l10n = MateyaLocalizations.current;
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return l10n.onboardingValidationNameRequired;
    }
    if (trimmed.runes.length > 30) {
      return l10n.onboardingValidationNameMaxLength;
    }
    if (_containsDisallowedNameCharacter(trimmed)) {
      return l10n.onboardingValidationNameCharacters;
    }
    return null;
  }

  static String? validatePhoneNumber(String value) {
    final l10n = MateyaLocalizations.current;
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return l10n.onboardingValidationPhoneRequired;
    }
    if (!_digitsOnly.hasMatch(digits)) {
      return l10n.onboardingValidationPhoneDigitsOnly;
    }
    if (digits.length > 15) {
      return l10n.onboardingValidationPhoneMaxLength;
    }
    if (digits.length < 9) {
      return l10n.onboardingValidationPhoneInvalid;
    }
    return null;
  }

  static String? validateVerificationCode(
    String input,
    String? expectedCode,
    bool isExpired,
  ) {
    final l10n = MateyaLocalizations.current;
    if (input.length != 6) {
      return l10n.onboardingValidationVerificationCodeRequired;
    }
    if (isExpired) {
      return l10n.onboardingValidationVerificationExpired;
    }
    if (expectedCode != null && input != expectedCode) {
      return l10n.onboardingValidationVerificationMismatch;
    }
    return null;
  }

  static String? validateBusinessName(String value) {
    if (value.trim().isEmpty) {
      return MateyaLocalizations
          .current
          .onboardingValidationBusinessNameRequired;
    }
    return null;
  }

  static String? validateBusinessOwner(String value) {
    return validateName(value);
  }

  static String? validateBusinessOpeningDate(String value) {
    final l10n = MateyaLocalizations.current;
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 8) {
      return l10n.onboardingValidationOpeningDateRequired;
    }
    final year = int.tryParse(digits.substring(0, 4));
    final month = int.tryParse(digits.substring(4, 6));
    final day = int.tryParse(digits.substring(6, 8));
    if (year == null || month == null || day == null) {
      return l10n.onboardingValidationOpeningDateDigitsOnly;
    }
    try {
      final parsed = DateTime(year, month, day);
      if (parsed.year != year || parsed.month != month || parsed.day != day) {
        return l10n.onboardingValidationOpeningDateInvalid;
      }
    } catch (_) {
      return l10n.onboardingValidationOpeningDateInvalid;
    }
    return null;
  }

  static String? validateBusinessNumber(
    String first,
    String second,
    String third,
  ) {
    final l10n = MateyaLocalizations.current;
    if (first.length != 3 || second.length != 2 || third.length != 5) {
      return l10n.onboardingValidationBusinessNumberRequired;
    }
    if (!(_digitsOnly.hasMatch(first) &&
        _digitsOnly.hasMatch(second) &&
        _digitsOnly.hasMatch(third))) {
      return l10n.onboardingValidationBusinessNumberDigitsOnly;
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
