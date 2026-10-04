import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class DoctorDetailsAppBar extends StatelessWidget {
  const DoctorDetailsAppBar({
    super.key,
    required this.onBack,
    required this.onSearch,
  });

  final VoidCallback onBack;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 16),
      child: Row(
        children: [
          AppIconButton.back(onTap: onBack, width: 30, height: 30),
          19.horizontalSpace,
          Expanded(
            child: Text(tr.doctorDetails, style: context.medium18TextMain),
          ),
          AppIconButton(
            onTap: onSearch,
            width: 30,
            height: 30,
            backgroundColor: AppColors.transparent,
            boxShadow: const [],
            icon: Icons.search_rounded,
            iconSize: 24,
          ),
        ],
      ),
    );
  }
}
