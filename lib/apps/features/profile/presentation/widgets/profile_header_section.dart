import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:flutter/material.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({
    super.key,
    this.avatarUrl,
    this.onBackTap,
    this.onCameraTap,
  });

  final String? avatarUrl;
  final VoidCallback? onBackTap;
  final VoidCallback? onCameraTap;

  @override
  Widget build(BuildContext context) {
    return AppHeaderSection(
      title: tr.profile,
      onBackTap: onBackTap,
      showSearchBar: false,
      bottom: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              tr.setUpYourProfile,
              style: context.bold18White,
              textAlign: TextAlign.center,
            ),
            8.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                tr.profileHeaderSubtitle,
                style: context.regular14White.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            24.verticalSpace,
            Stack(
              alignment: Alignment.center,
              children: [
                ProfileAvatar(avatarUrl: avatarUrl, size: 130),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: AppIconButton(
                    width: 36,
                    height: 36,
                    borderRadius: BorderRadius.circular(18),
                    backgroundColor: const Color(0xCC677294),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [],
                    icon: Icons.camera_alt_outlined,
                    iconSize: 18,
                    iconColor: Colors.white,
                    onTap: onCameraTap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
