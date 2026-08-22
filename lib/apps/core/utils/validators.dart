import 'package:doctor_hunt/generated/i18n/translations.g.dart';

abstract final class AppValidators {
  static String? validateEmail(String? value, Translations t) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return t.enterEmailAddress;
    if (!email.contains('@') || !email.contains('.')) {
      return t.enterValidEmailAddress;
    }
    return null;
  }

  static String? validatePassword(String? value, Translations t) {
    if ((value ?? '').length < 8) {
      return t.useAtLeast8Characters;
    }
    return null;
  }

  static String? validateRequiredPassword(String? value, Translations t) {
    if ((value ?? '').isEmpty) {
      return t.enterPassword;
    }
    return null;
  }

  static String? validateName(String? value, Translations t) {
    if (value == null || value.trim().isEmpty) {
      return t.enterFullName;
    }
    return null;
  }
}
