import 'package:shared_preferences/shared_preferences.dart';

/// Provides access to persistent app preferences such as the first-time onboarding flag.
class AppPreferencesService {
  AppPreferencesService({required this.preferences});

  final SharedPreferences preferences;

  static const String _keyHasSeenOnboarding = 'has_seen_onboarding';

  /// Whether the user has completed or skipped the onboarding flow at least once.
  bool get hasSeenOnboarding =>
      preferences.getBool(_keyHasSeenOnboarding) ?? false;

  /// Updates the onboarding completion flag.
  Future<bool> setHasSeenOnboarding(bool value) =>
      preferences.setBool(_keyHasSeenOnboarding, value);
}
