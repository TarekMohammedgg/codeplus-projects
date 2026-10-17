import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/apps/core/services/app_preferences_service.dart';

import '../../helpers/test_fakes.dart';

void main() {
  test('languageCode is null until a language is saved', () {
    // arrange
    final service = AppPreferencesService(preferences: FakeSharedPreferences());

    // act
    final code = service.languageCode;

    // assert
    expect(code, isNull);
  });

  test('setLanguageCode is read back by languageCode', () async {
    // arrange
    final service = AppPreferencesService(preferences: FakeSharedPreferences());

    // act
    await service.setLanguageCode('ar');

    // assert
    expect(service.languageCode, 'ar');
  });
}
