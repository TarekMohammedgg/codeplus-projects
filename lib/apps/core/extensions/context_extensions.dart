import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  void unfocus() => FocusScope.of(this).unfocus();

  String get localeCode =>
      TranslationProvider.of(this).translations.$meta.locale.languageCode;
}
