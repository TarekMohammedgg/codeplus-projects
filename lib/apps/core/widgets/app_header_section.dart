import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_search_bar.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AppHeaderSection extends StatelessWidget {
  const AppHeaderSection({
    super.key,
    this.greeting,
    this.title,
    this.titleWidget,
    this.leading,
    this.onBackTap,
    this.trailing,
    this.showSettings = false,
    this.onSettingsTap,
    this.showProfile = false,
    this.profileImage,
    this.onProfileTap,
    this.showSearchBar = true,
    this.searchController,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchClear,
    this.searchHintText,
    this.searchWidget,
    this.bottom,
    this.gradient,
    this.padding,
    this.borderRadius,
    this.backgroundImage,
  });

  final String? greeting;
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final VoidCallback? onBackTap;
  final Widget? trailing;
  final bool showSettings;
  final VoidCallback? onSettingsTap;
  final bool showProfile;
  final String? profileImage;
  final VoidCallback? onProfileTap;
  final bool showSearchBar;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onSearchClear;
  final String? searchHintText;
  final Widget? searchWidget;
  final Widget? bottom;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final DecorationImage? backgroundImage;

  @override
  Widget build(BuildContext context) {
    final effectiveGradient =
        gradient ??
        const LinearGradient(
          colors: [AppColors.primaryGreen, Color(0xFF07D9AD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

    final effectiveBorderRadius =
        borderRadius ??
        const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        );

    final effectiveBackgroundImage =
        backgroundImage ??
        const DecorationImage(
          image: AssetImage(Assets.assetsDesignTopHover),
          fit: BoxFit.cover,
          opacity: 0.15,
        );

    final effectivePadding =
        padding ??
        const EdgeInsets.only(left: 24, right: 24, top: 60, bottom: 36);

    return Container(
      width: double.infinity,
      padding: effectivePadding,
      decoration: BoxDecoration(
        gradient: effectiveGradient,
        borderRadius: effectiveBorderRadius,
        image: effectiveBackgroundImage,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leading != null)
                leading!
              else if (onBackTap != null)
                AppIconButton(
                  onTap: onBackTap,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  boxShadow: const [],
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              if (leading != null || onBackTap != null) 12.horizontalSpace,
              Expanded(
                child:
                    titleWidget ??
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (greeting != null && greeting!.isNotEmpty) ...[
                          Text(
                            greeting!,
                            style: context.regular16White.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 15,
                            ),
                          ),
                          4.verticalSpace,
                        ],
                        if (title != null && title!.isNotEmpty)
                          Text(
                            title!,
                            style: context.bold22White.copyWith(height: 1.25),
                          ),
                      ],
                    ),
              ),
              if (trailing != null)
                trailing!
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showSettings || onSettingsTap != null)
                      IconButton(
                        onPressed: onSettingsTap,
                        icon: const Icon(
                          Icons.settings_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                      ),
                    if ((showSettings || onSettingsTap != null) &&
                        (showProfile || profileImage != null))
                      4.horizontalSpace,
                    if (showProfile || profileImage != null)
                      GestureDetector(
                        onTap: onProfileTap,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x24000000),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: profileImage != null
                                ? Image.asset(
                                    profileImage!,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const DoctorAvatarPlaceholder(
                                              size: 48,
                                              iconColor: AppColors.primaryGreen,
                                              backgroundColor: Color(
                                                0xFFE8FBF6,
                                              ),
                                            ),
                                  )
                                : const DoctorAvatarPlaceholder(
                                    size: 48,
                                    iconColor: AppColors.primaryGreen,
                                    backgroundColor: Color(0xFFE8FBF6),
                                  ),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
          if (showSearchBar || searchWidget != null || bottom != null) ...[
            20.verticalSpace,
            if (searchWidget != null)
              searchWidget!
            else if (showSearchBar)
              AppSearchBar(
                controller: searchController,
                hintText: searchHintText,
                onChanged: onSearchChanged,
                onSubmitted: onSearchSubmitted,
                onClear: onSearchClear,
              ),
            if (bottom != null) ...[
              if (showSearchBar || searchWidget != null) 16.verticalSpace,
              bottom!,
            ],
          ],
        ],
      ),
    );
  }
}
