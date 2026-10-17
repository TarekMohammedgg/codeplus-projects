import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_back_button.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final bodyStyle = context.light14TextSecondary.copyWith(
      color: AppColors.textMuted,
      height: 1.65,
    );

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.background,
        image: DecorationImage(
          image: AssetImage(Assets.assetsDesignSplashBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        appBar: AppBar(
          leadingWidth: 50,
          leading: AppBackButton.leading(onTap: () => context.pop()),
          titleSpacing: 19,
          title: Text(tr.privacyPolicy, style: context.medium18TextMain),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tr.privacyPolicyTitle, style: context.bold18TextSecondary),
              12.verticalSpace,
              Text(tr.privacyPolicyIntro, style: bodyStyle),
              20.verticalSpace,
              for (final bullet in [
                tr.privacyPolicyBullet1,
                tr.privacyPolicyBullet2,
                tr.privacyPolicyBullet3,
                tr.privacyPolicyBullet4,
              ])
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 13,
                    bottom: 20,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: AppColors.primary,
                        ),
                      ),
                      8.horizontalSpace,
                      Expanded(child: Text(bullet, style: bodyStyle)),
                    ],
                  ),
                ),
              Text(tr.privacyPolicyOutro, style: bodyStyle),
            ],
          ),
        ),
      ),
    );
  }
}
