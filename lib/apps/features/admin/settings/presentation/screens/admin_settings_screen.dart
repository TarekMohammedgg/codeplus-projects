import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:doctor_hunt/apps/core/di/injection.dart';

import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_header_section.dart';
import 'package:doctor_hunt/apps/core/widgets/doctor_avatar_placeholder.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_state.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key, this.repository});

  final AuthRepository? repository;

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  late final AuthService _authService;
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authService = getIt.isRegistered<AuthService>()
        ? getIt<AuthService>()
        : AuthService(
            auth: getIt.isRegistered<FirebaseAuth>()
                ? getIt<FirebaseAuth>()
                : FirebaseAuth.instance,
            firestore: getIt.isRegistered<FirebaseFirestore>()
                ? getIt<FirebaseFirestore>()
                : FirebaseFirestore.instance,
          );
    _authCubit = AuthCubit(
      repository:
          widget.repository ??
          (getIt.isRegistered<AuthRepository>()
              ? getIt<AuthRepository>()
              : FirebaseAuthRepository(authService: _authService)),
    );
  }

  @override
  void dispose() {
    _authCubit.close();
    super.dispose();
  }

  void _onLogOut() {
    _authCubit.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final email = _authService.currentUser?.email ?? '';

    return BlocProvider.value(
      value: _authCubit,
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          switch (state) {
            case AuthFailure(:final errorMessage):
              context.showErrorSnackBar(errorMessage);
            case AuthSuccess(action: AuthAction.signOut):
              const RoleSelectionRoute().go(context);
            default:
              break;
          }
        },
        builder: (context, state) {
          final isLoggingOut =
              state is AuthLoading && state.action == AuthAction.signOut;

          return Scaffold(
            backgroundColor: AppColors.background,
            body: Column(
              children: [
                AppHeaderSection(
                  title: tr.settings,
                  onBackTap: () => context.pop(),
                  showSearchBar: false,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const DoctorAvatarPlaceholder(size: 56),
                            14.horizontalSpace,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tr.adminRoleTitle,
                                    style: context.semiBold16TextMain,
                                  ),
                                  2.verticalSpace,
                                  Text(
                                    email,
                                    style: context.regular14TextSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        32.verticalSpace,
                        //CR use primary widget (any reuse widget)
                        OutlinedButton.icon(
                          onPressed: isLoggingOut ? null : _onLogOut,
                          icon: const Icon(
                            Icons.logout_rounded,
                            color: AppColors.error,
                          ),
                          label: Text(
                            tr.logOut,
                            style: context.semiBold16TextMain.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                          //CR use primary widget (any reuse widget)
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
