import 'package:doctor_hunt/apps/core/utils/phone_utils.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

abstract final class AppValidators {
  static String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return tr.enterEmailAddress;
    if (!email.contains('@') || !email.contains('.')) {
      return tr.enterValidEmailAddress;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if ((value ?? '').length < 8) {
      return tr.useAtLeast8Characters;
    }
    return null;
  }

  static String? validateRequiredPassword(String? value) {
    if ((value ?? '').isEmpty) {
      return tr.enterPassword;
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return tr.enterFullName;
    }
    return null;
  }

  static String? validatePhone(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) {
      return 'يرجى إدخال رقم الهاتف';
    }
    if (!PhoneUtils.isValidPhone(phone)) {
      return 'يرجى إدخال رقم هاتف صحيح (مثال: 01012345678)';
    }
    return null;
  }
}
