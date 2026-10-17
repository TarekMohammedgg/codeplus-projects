import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_profile_avatar.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:flutter/material.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({
    super.key,
    this.avatarUrl,
    this.onBackTap,
    this.onCameraTap,
    this.onEditTap,
  });

  final String? avatarUrl;
  final VoidCallback? onBackTap;
  final VoidCallback? onCameraTap;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    final effectiveEditTap = onEditTap ?? onCameraTap;

    return AppHeaderSection(
      title: tr.profile,
      onBackTap: onBackTap,
      showSearchBar: false,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 48, bottom: 20),
      trailing: effectiveEditTap != null
          ? AppIconButton(
              width: 40,
              height: 40,
              borderRadius: BorderRadius.circular(12),
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              boxShadow: const [],
              icon: Icons.edit_outlined,
              iconSize: 20,
              iconColor: Colors.white,
              onTap: effectiveEditTap,
            )
          : null,
      bottom: SizedBox(
        width: double.infinity,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              AppProfileAvatar(imageUrl: avatarUrl, size: 110, elevated: true),
              Positioned(
                bottom: 2,
                right: 2,
                child: AppIconButton(
                  width: 36,
                  height: 36,
                  borderRadius: BorderRadius.circular(18),
                  //CR hardcode color
                  // Solved
                  backgroundColor: AppColors.textSecondary.withValues(
                    alpha: 0.8,
                  ),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [],
                  icon: Icons.camera_alt_outlined,
                  iconSize: 18,
                  iconColor: Colors.white,
                  onTap: effectiveEditTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
