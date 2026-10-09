abstract final class PhoneUtils {
  static const String defaultCountryCode = '+20';

  static String normalizePhoneNumber(
    String? rawPhone, {
    String fallbackCountryCode = defaultCountryCode,
  }) {
    if (rawPhone == null) return '';
    String cleaned = rawPhone.trim().replaceAll(RegExp(r'[\s\-()]+'), '');
    if (cleaned.isEmpty) return '';

    cleaned = _convertEasternToWesternDigits(cleaned);

    if (cleaned.startsWith('00')) {
      cleaned = '+${cleaned.substring(2)}';
    }

    if (cleaned.startsWith('+')) {
      return cleaned;
    }

    if (cleaned.startsWith('20') && cleaned.length == 12) {
      return '+$cleaned';
    }

    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
      return '$fallbackCountryCode$cleaned';
    }

    return '$fallbackCountryCode$cleaned';
  }

  static String formatForDisplay(String? rawPhone) {
    final normalized = normalizePhoneNumber(rawPhone);
    if (normalized.isEmpty) return '';

    if (normalized.startsWith('+20') && normalized.length == 13) {
      final country = normalized.substring(0, 3);
      final network = normalized.substring(3, 5);
      final part1 = normalized.substring(5, 9);
      final part2 = normalized.substring(9);
      return '$country $network $part1 $part2';
    }

    return normalized;
  }

  static bool isValidPhone(String? rawPhone) {
    if (rawPhone == null || rawPhone.trim().isEmpty) return false;
    final normalized = normalizePhoneNumber(rawPhone);

    if (normalized.startsWith('+20')) {
      final localPart = normalized.substring(3);
      return RegExp(r'^(10|11|12|15)\d{8}$').hasMatch(localPart);
    }

    return RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(normalized);
  }

  static String _convertEasternToWesternDigits(String input) {
    const easternDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const westernDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    String result = input;
    for (int i = 0; i < 10; i++) {
      result = result.replaceAll(easternDigits[i], westernDigits[i]);
    }
    return result;
  }
}
