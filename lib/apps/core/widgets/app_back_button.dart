import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onTap}) : _asLeading = false;

  const AppBackButton.leading({super.key, this.onTap}) : _asLeading = true;

  final VoidCallback? onTap;
  final bool _asLeading;

  static const double size = 30;

  @override
  Widget build(BuildContext context) {
    final button = AppIconButton.back(
      width: size,
      height: size,
      tooltip: context.tr.back,
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
    );
    if (!_asLeading) return button;

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 20),
      child: Align(alignment: AlignmentDirectional.centerStart, child: button),
    );
  }
}
