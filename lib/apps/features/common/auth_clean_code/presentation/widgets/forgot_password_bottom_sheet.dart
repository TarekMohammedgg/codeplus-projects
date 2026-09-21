import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/extensions/custom_snack_bar.dart';
import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/utils/validators.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_field.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_code/domain/repositories/auth_repository.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_code/presentation/cubit/auth_cubit.dart';
import 'package:doctor_hunt/apps/features/common/auth_clean_code/presentation/cubit/auth_state.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class ForgotPasswordBottomSheet extends StatefulWidget {
  const ForgotPasswordBottomSheet({super.key, this.cubit, this.repository});

  final AuthCubit? cubit;
  final AuthRepository? repository;

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => const ForgotPasswordBottomSheet(),
    );
  }

  @override
  State<ForgotPasswordBottomSheet> createState() =>
      ForgotPasswordBottomSheetState();
}

class ForgotPasswordBottomSheetState extends State<ForgotPasswordBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit =
        widget.cubit ??
        (widget.repository != null
            ? AuthCubit.fromRepository(widget.repository!)
            : AuthCubit.create());
  }

  @override
  void dispose() {
    emailController.dispose();
    _authCubit.close();
    super.dispose();
  }

  void onContinue() {
    if (!formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    _authCubit.resetPassword(email: emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return BlocProvider.value(
      value: _authCubit,
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          switch (state) {
            case AuthSuccess(action: AuthAction.resetPassword):
              Navigator.of(context).pop();
              context.showSuccessSnackBar(tr.passwordResetSuccess);
            case AuthFailure(:final errorMessage):
              Navigator.of(context).pop();
              context.showErrorSnackBar(errorMessage);
            default:
              break;
          }
        },
        builder: (context, state) {
          final isLoading =
              state is AuthLoading && state.action == AuthAction.resetPassword;

          return Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: 54,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.outline,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        24.verticalSpace,
                        Text(tr.forgotPassword, style: context.bold24TextMain),
                        10.verticalSpace,
                        Text(
                          tr.forgotPasswordSubtitle,
                          style: context.regular14TextSecondary.copyWith(
                            height: 1.4,
                          ),
                        ),
                        24.verticalSpace,
                        AppTextField(
                          controller: emailController,
                          hintText: tr.emailAddress,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.email],
                          validator: (value) =>
                              AppValidators.validateEmail(value),
                          onFieldSubmitted: (_) => onContinue(),
                        ),
                        24.verticalSpace,
                        AppPrimaryButton(
                          label: tr.continueText,
                          isLoading: isLoading,
                          onPressed: isLoading ? null : onContinue,
                          height: 52,
                        ),
                        8.verticalSpace,
                      ],
                    ),
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
