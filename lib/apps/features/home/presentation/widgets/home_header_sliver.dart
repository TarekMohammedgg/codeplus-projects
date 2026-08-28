import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/features/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class HomeHeaderSliver extends StatelessWidget {
  const HomeHeaderSliver({
    super.key,
    required this.searchController,
    required this.onProfileTap,
    this.authService,
  });

  final TextEditingController searchController;
  final VoidCallback onProfileTap;
  final AuthService? authService;

  @override
  Widget build(BuildContext context) {
    final auth = authService ?? AuthService();
    final user = auth.currentUser;

    return SliverToBoxAdapter(
      child: AppHeaderSection(
        greeting: auth.getUserGreeting(context),
        title: tr.findYourDoctor,
        searchController: searchController,
        showLanguageToggle: true,
        showProfile: true,
        profileImage: user?.photoURL,
        onProfileTap: onProfileTap,
      ),
    );
  }
}
