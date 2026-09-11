import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/validators.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_field.dart';
import 'package:doctor_hunt/apps/features/admin/presentation/widgets/admin_login_widgets.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/cubit/auth_state.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/widgets/auth_back_button.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/widgets/auth_header.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key, this.repository});

  final AuthRepository? repository;

  @override
  State<AdminLoginScreen> createState() => AdminLoginScreenState();
}

class AdminLoginScreenState extends State<AdminLoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = AuthCubit(
      repository:
          widget.repository ??
          FirebaseAuthRepository(authService: AuthService()),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _authCubit.close();
    super.dispose();
  }

  void signIn() {
    if (!formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    _authCubit.signInAsAdmin(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authCubit,
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          switch (state) {
            case AuthFailure(:final errorMessage):
              context.showErrorSnackBar(errorMessage);
            case AuthSuccess(action: AuthAction.adminSignIn):
              const AdminDoctorsRoute().go(context);
            default:
              break;
          }
        },
        builder: (context, state) {
          final isLoading =
              state is AuthLoading && state.action == AuthAction.adminSignIn;

          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      16.verticalSpace,
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: AuthBackButton(
                          circular: true,
                          onPressed: () =>
                              const RoleSelectionRoute().go(context),
                        ),
                      ),
                      24.verticalSpace,
                      const Center(child: AdminLogo()),
                      20.verticalSpace,
                      AuthHeader(
                        title: tr.adminLoginTitle,
                        subtitle: tr.adminLoginSubtitle,
                      ),
                      32.verticalSpace,
                      AppTextField(
                        controller: emailController,
                        hintText: tr.adminEmailHint,
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        validator: (value) =>
                            AppValidators.validateEmail(value),
                      ),
                      18.verticalSpace,
                      AppTextField(
                        controller: passwordController,
                        hintText: tr.enterPasswordHint,
                        prefixIcon: Icons.lock_outline_rounded,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        onFieldSubmitted: (_) => signIn(),
                        validator: (value) =>
                            AppValidators.validateRequiredPassword(value),
                      ),
                      28.verticalSpace,
                      AppPrimaryButton(
                        label: tr.logIn,
                        isLoading: isLoading,
                        onPressed: isLoading ? null : signIn,
                        height: 54,
                        fontSize: 16,
                      ),
                      20.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.lock_outline_rounded,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          8.horizontalSpace,
                          Text(
                            tr.secureAdminAccessOnly,
                            style: context.regular12TextSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
