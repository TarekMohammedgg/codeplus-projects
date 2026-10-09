import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/widgets/app_logout_dialog.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/bottom_navigation_bar/presentation/widgets/main_bottom_navigation_bar.dart';
import 'package:doctor_hunt/apps/features/common/shell/presentation/widgets/patient_menu_drawer.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_cubit.dart';
import 'package:doctor_hunt/apps/features/patient/favorites/presentation/controller/cubit/favorites_state.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

class PatientShell extends StatelessWidget {
  const PatientShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  Future<void> _confirmLogOut(BuildContext context) async {
    final confirmed = await showLogoutConfirmDialog(context);
    if (confirmed && context.mounted) {
      await context.read<AuthCubit>().signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesCubit, FavoritesState>(
      listenWhen: (_, current) => current is FavoritesFailure,
      listener: (context, _) => context.showCustomSnackBar(
        message: context.tr.favoriteUpdateFailed,
        status: SnackBarStatus.error,
      ),
      child: Scaffold(
        body: navigationShell,
        drawerEdgeDragWidth: 60,
        drawer: PatientMenuDrawer(
          onTabTap: navigationShell.goBranch,
          onSettingsTap: () => const PatientSettingsRoute().push(context),
          onLogoutTap: () => _confirmLogOut(context),
        ),
        bottomNavigationBar: MainBottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
        ),
      ),
    );
  }
}
