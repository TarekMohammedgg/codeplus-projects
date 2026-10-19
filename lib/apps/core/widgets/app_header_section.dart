import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_back_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_search_bar.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_image.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
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
    this.showLanguageToggle = false,
    this.onLanguageToggle,
    this.showProfile = false,
    this.profileImage,
    this.onProfileTap,
    this.showSearchBar = true,
    this.searchReadOnly = false,
    this.onSearchTap,
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
  final bool showLanguageToggle;
  final VoidCallback? onLanguageToggle;
  final bool showProfile;
  final String? profileImage;
  final VoidCallback? onProfileTap;
  final bool showSearchBar;
  final bool searchReadOnly;
  final VoidCallback? onSearchTap;
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
          //CR hardcode color
          // Solved
          colors: [AppColors.primary, AppColors.secondary],
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

    final currentLocale = TranslationProvider.of(context).locale;
    final isArabic = currentLocale == AppLocale.ar;
    final targetLangLabel = isArabic ? 'EN' : 'ع';
    final langIcon = isArabic
        ? Icons.translate_rounded
        : Icons.language_rounded;

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
                AppBackButton(onTap: onBackTap),
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
                            style: context.regular15White.copyWith(
                              color: AppColors.white.withValues(alpha: 0.9),
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
                    if (showLanguageToggle || onLanguageToggle != null)
                      Material(
                        color: AppColors.transparent,
                        child: InkWell(
                          onTap:
                              onLanguageToggle ??
                              () {
                                final next = isArabic
                                    ? AppLocale.en
                                    : AppLocale.ar;
                                LocaleSettings.setLocaleSync(next);
                              },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  langIcon,
                                  color: AppColors.white,
                                  size: 18,
                                ),
                                6.horizontalSpace,
                                Text(
                                  targetLangLabel,
                                  //CR hardcode textstyle
                                  // Solved
                                  style: context.bold13White,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if ((showLanguageToggle || onLanguageToggle != null) &&
                        (showProfile || profileImage != null))
                      8.horizontalSpace,
                    if (showProfile || profileImage != null)
                      GestureDetector(
                        onTap: onProfileTap,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white.withValues(alpha: 0.7),
                              width: 2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                //CR hardcode color
                                // Solved
                                color: AppColors.shadowStrong,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: DoctorImage(
                              imageUrl: profileImage,
                              width: 48,
                              height: 48,
                              //CR hardcode color
                              // Solved
                              fallback: const DoctorAvatarPlaceholder(),
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
                readOnly: searchReadOnly,
                onTap: onSearchTap,
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
