import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/widgets/app_confirm_dialog.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

Future<bool> showLogoutConfirmDialog(BuildContext context) {
  return showAppConfirmDialog(
    context,
    title: context.tr.logOutConfirmTitle,
    message: context.tr.logOutConfirmMessage,
    confirmLabel: context.tr.ok,
    titleStyle: context.bold24TextMain,
    cancelTextStyle: context.semiBold14,
  );
}
