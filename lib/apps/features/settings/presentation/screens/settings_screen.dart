import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final isArabic = t.$meta.locale == AppLocale.ar;
    final nextLocale = isArabic ? AppLocale.en : AppLocale.ar;

    return Scaffold(
      appBar: AppBar(title: Text(t.settings)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ListTile(
          tileColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.outline),
          ),
          leading: const Icon(
            Icons.language_rounded,
            color: AppColors.primaryGreen,
          ),
          title: Text(t.language, style: context.semiBold16TextMain),
          subtitle: Text(
            isArabic ? t.arabicLanguage : t.englishLanguage,
            style: context.regular14TextSub,
          ),
          trailing: TextButton(
            onPressed: () => LocaleSettings.setLocale(nextLocale),
            child: Text(isArabic ? t.englishLanguage : t.arabicLanguage),
          ),
        ),
      ),
    );
  }
}
