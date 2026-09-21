import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doctor_hunt/apps/core/di/injection.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_field.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/controller/cubit/auth_state.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/widgets/auth_back_button.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/widgets/auth_buttons.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/widgets/auth_header.dart';
import 'package:doctor_hunt/apps/features/common/auth/presentation/widgets/forgot_password_bottom_sheet.dart';
import 'package:doctor_hunt/apps/features/common/role_selection/data/models/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/validators.dart';
import 'package:doctor_hunt/generated/app_image.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.repository, this.role});

  final AuthRepository? repository;
  final UserRole? role;

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    //CR [Correct DI Approach for Cubit in UI Layer]:
    //CR Eliminate defensive nested ternaries and manual fallback constructor chains (`new FirebaseAuthRepository(AuthService())`).
    //CR Option A (Direct GetIt):
    //CR   `_authCubit = widget.cubit ?? getIt<AuthCubit>();`
    //CR Option B (Provider in Route/Screen):
    //CR   Provide the Cubit at the route level: `BlocProvider(create: (_) => getIt<AuthCubit>(), child: const LoginScreen())`
    _authCubit = widget.repository != null
        ? AuthCubit(repository: widget.repository!)
        : (getIt.isRegistered<AuthCubit>()
              ? getIt<AuthCubit>()
              : AuthCubit(
                  repository: getIt.isRegistered<AuthRepository>()
                      ? getIt<AuthRepository>()
                      : FirebaseAuthRepository(
                          authService: getIt.isRegistered<AuthService>()
                              ? getIt<AuthService>()
                              : AuthService(
                                  auth: getIt.isRegistered<FirebaseAuth>()
                                      ? getIt<FirebaseAuth>()
                                      : FirebaseAuth.instance,
                                  firestore:
                                      getIt.isRegistered<FirebaseFirestore>()
                                      ? getIt<FirebaseFirestore>()
                                      : FirebaseFirestore.instance,
                                ),
                        ),
                ));
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

    if (widget.role == UserRole.admin) {
      _authCubit.signInAsAdmin(
        email: emailController.text,
        password: passwordController.text,
      );
    } else {
      _authCubit.signIn(
        email: emailController.text,
        password: passwordController.text,
      );
    }
  }

  void signInWithGoogle() {
    FocusScope.of(context).unfocus();
    _authCubit.signInWithGoogle();
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
            case AuthSuccess(action: AuthAction.signIn) ||
                AuthSuccess(action: AuthAction.googleSignIn):
              const HomeRoute().go(context);
            default:
              break;
          }
        },
        builder: (context, state) {
          final isAdmin = widget.role == UserRole.admin;
          final isAnyLoading = state is AuthLoading;
          final isEmailLoading =
              state is AuthLoading &&
              (state.action == AuthAction.signIn ||
                  state.action == AuthAction.adminSignIn);
          final isGoogleLoading =
              state is AuthLoading && state.action == AuthAction.googleSignIn;

          return Scaffold(
            backgroundColor: AppColors.background,
            body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isAdmin) ...[
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: AuthBackButton(
                          circular: true,
                          onPressed: () =>
                              const RoleSelectionRoute().go(context),
                        ),
                      ),
                      16.verticalSpace,
                    ],
                    28.verticalSpace,
                    AuthHeader(
                      title: isAdmin ? tr.adminLoginTitle : tr.welcomeBack,
                      subtitle: isAdmin
                          ? tr.adminLoginSubtitle
                          : tr.loginSubtitle,
                    ),
                    if (!isAdmin) ...[
                      32.verticalSpace,
                      SocialAuthButton(
                        label: tr.google,
                        image: Assets.assetsDesignGoogleLogo,
                        isLoading: isGoogleLoading,
                        onPressed: isAnyLoading ? null : signInWithGoogle,
                      ),
                    ],
                    32.verticalSpace,
                    AppTextField(
                      controller: emailController,
                      hintText: isAdmin ? tr.adminEmailHint : tr.emailHint,
                      prefixIcon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      validator: (value) => AppValidators.validateEmail(value),
                    ),
                    18.verticalSpace,
                    AppPasswordTextField(
                      controller: passwordController,
                      hintText: tr.enterPasswordHint,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: (_) => signIn(),
                      validator: (value) =>
                          AppValidators.validateRequiredPassword(value),
                    ),
                    if (!isAdmin) _ForgotPasswordButton(disabled: isAnyLoading),
                    24.verticalSpace,
                    AppPrimaryButton(
                      label: tr.logIn,
                      isLoading: isEmailLoading,
                      onPressed: isAnyLoading ? null : signIn,
                      height: 54,
                      fontSize: 16,
                    ),
                    if (!isAdmin) ...[
                      28.verticalSpace,
                      _SignUpFooter(disabled: isAnyLoading),
                    ] else ...[
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  final bool disabled;

  const _ForgotPasswordButton({this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      //CR use primary widget (any reuse widget)
      child: TextButton(
        onPressed: disabled
            ? null
            : () => ForgotPasswordBottomSheet.show(context),
        //CR use primary widget (any reuse widget)
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: context.medium14Primary.copyWith(fontSize: 13.5),
        ),
        child: Text(tr.forgotPassword),
      ),
    );
  }
}

class _SignUpFooter extends StatelessWidget {
  final bool disabled;

  const _SignUpFooter({this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(tr.dontHaveAccount, style: context.regular14TextSecondary),
          //CR use primary widget (any reuse widget)
          TextButton(
            onPressed: disabled
                ? null
                : () => const SignupRoute().push(context),
            //CR use primary widget (any reuse widget)
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.only(left: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: context.semiBold14Primary,
            ),
            child: Text(tr.joinUs),
          ),
        ],
      ),
    );
  }
}
