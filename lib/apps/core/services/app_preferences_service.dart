import 'package:shared_preferences/shared_preferences.dart';

class AppPreferencesService {
  AppPreferencesService({required this.preferences});

  final SharedPreferences preferences;

  static const String _keyHasSeenOnboarding = 'has_seen_onboarding';

  static const String _keyLanguageCode = 'language_code';

  String? get languageCode => preferences.getString(_keyLanguageCode);

  Future<bool> setLanguageCode(String code) =>
      preferences.setString(_keyLanguageCode, code);

  bool get hasSeenOnboarding =>
      preferences.getBool(_keyHasSeenOnboarding) ?? false;

  Future<bool> setHasSeenOnboarding(bool value) =>
      preferences.setBool(_keyHasSeenOnboarding, value);
}
