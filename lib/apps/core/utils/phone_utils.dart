abstract final class PhoneUtils {
  static const String defaultCountryCode = '+20';

  /// Normalizes any raw phone input to E.164 format.
  /// If the user did not provide a country code, it automatically adds the Egyptian country code (+20).
  ///
  /// Examples:
  /// - '01012345678' -> '+201012345678'
  /// - '1012345678'  -> '+201012345678'
  /// - '+201012345678' -> '+201012345678'
  /// - '00201012345678' -> '+201012345678'
  /// - '010 1234 5678' -> '+201012345678'
  /// - '+966501234567' -> '+966501234567'
  static String normalizePhoneNumber(
    String? rawPhone, {
    String fallbackCountryCode = defaultCountryCode,
  }) {
    if (rawPhone == null) return '';
    String cleaned = rawPhone.trim().replaceAll(RegExp(r'[\s\-()]+'), '');
    if (cleaned.isEmpty) return '';

    // Convert Arabic/Eastern digits to Western digits if any
    cleaned = _convertEasternToWesternDigits(cleaned);

    // Convert 00 prefix to +
    if (cleaned.startsWith('00')) {
      cleaned = '+${cleaned.substring(2)}';
    }

    // Already has international code with '+'
    if (cleaned.startsWith('+')) {
      return cleaned;
    }

    // 12-digit number starting with 20 (e.g. 201012345678)
    if (cleaned.startsWith('20') && cleaned.length == 12) {
      return '+$cleaned';
    }

    // Standard Egyptian 11-digit mobile starting with 01 (e.g. 010..., 011..., 012..., 015...)
    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
      return '$fallbackCountryCode$cleaned';
    }

    // 10-digit mobile (e.g. 1012345678, 11..., 12..., 15...)
    return '$fallbackCountryCode$cleaned';
  }

  /// Formats the phone number for clean UI display.
  /// For Egyptian numbers (+20XXXXXXXXXX), outputs: +20 XX XXXX XXXX
  static String formatForDisplay(String? rawPhone) {
    final normalized = normalizePhoneNumber(rawPhone);
    if (normalized.isEmpty) return '';

    if (normalized.startsWith('+20') && normalized.length == 13) {
      final country = normalized.substring(0, 3); // +20
      final network = normalized.substring(3, 5); // 10, 11, 12, 15
      final part1 = normalized.substring(5, 9);
      final part2 = normalized.substring(9);
      return '$country $network $part1 $part2';
    }

    return normalized;
  }

  /// Validates whether the given string represents a valid phone number.
  static bool isValidPhone(String? rawPhone) {
    if (rawPhone == null || rawPhone.trim().isEmpty) return false;
    final normalized = normalizePhoneNumber(rawPhone);

    // Egyptian mobile validation (+20 followed by 10, 11, 12, 15 and 8 digits)
    if (normalized.startsWith('+20')) {
      final localPart = normalized.substring(3);
      return RegExp(r'^(10|11|12|15)\d{8}$').hasMatch(localPart);
    }

    // General international E.164 phone validation (8 to 15 digits total)
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
