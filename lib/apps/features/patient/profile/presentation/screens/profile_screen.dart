import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/cubit/auth_state.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/models/user_profile_model.dart';
import 'package:doctor_hunt/apps/features/patient/profile/data/profile_data.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/widgets/profile_header_section.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/widgets/profile_info_card.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.profile, this.repository});

  final UserProfileModel? profile;
  final AuthRepository? repository;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = widget.repository != null
        ? AuthCubit(repository: widget.repository!)
        : (getIt.isRegistered<AuthCubit>()
              ? getIt<AuthCubit>()
              : AuthCubit(
                  repository: getIt.isRegistered<AuthRepository>()
                      ? getIt<AuthRepository>()
                      : FirebaseAuthRepository(authService: AuthService()),
                ));
  }

  @override
  void dispose() {
    _authCubit.close();
    super.dispose();
  }

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      const HomeRoute().go(context);
    }
  }

  void _onLogOut() {
    _authCubit.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = widget.profile ?? defaultUserProfile();

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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileHeaderSection(
                          avatarUrl: userProfile.avatarUrl,
                          onBackTap: () => _onBack(context),
                          onCameraTap: () {},
                        ),
                        24.verticalSpace,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr.personalInformation,
                                style: context.bold18TextMain.copyWith(
                                  fontSize: 18,
                                  color: const Color(0xFF333333),
                                ),
                              ),
                              16.verticalSpace,
                              ProfileInfoCard(
                                label: tr.fullName,
                                value: userProfile.name,
                              ),
                              10.verticalSpace,
                              ProfileInfoCard(
                                label: tr.contactNumber,
                                value: userProfile.contactNumber,
                                showEditIcon: true,
                                onEdit: () {},
                              ),
                              10.verticalSpace,
                              ProfileInfoCard(
                                label: tr.dateOfBirth,
                                value: userProfile.dateOfBirth,
                                showEditIcon: true,
                                onEdit: () {},
                              ),
                              10.verticalSpace,
                              ProfileInfoCard(
                                label: tr.location,
                                value: userProfile.location,
                              ),
                              24.verticalSpace,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                    child: AppPrimaryButton(
                      label: tr.logOut,
                      icon: Icons.logout_rounded,
                      backgroundColor: AppColors.error,
                      isLoading: isLoggingOut,
                      onPressed: isLoggingOut ? null : _onLogOut,
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
