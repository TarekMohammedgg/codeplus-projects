import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/services/app_preferences_service.dart';

import '../../../helpers/test_fakes.dart';

void main() {
  test('languageCode is null until a language is saved', () {
    final service = AppPreferencesService(preferences: FakeSharedPreferences());

    final code = service.languageCode;

    expect(code, isNull);
  });

  test('setLanguageCode is read back by languageCode', () async {
    final service = AppPreferencesService(preferences: FakeSharedPreferences());

    await service.setLanguageCode('ar');

    expect(service.languageCode, 'ar');
  });
}
