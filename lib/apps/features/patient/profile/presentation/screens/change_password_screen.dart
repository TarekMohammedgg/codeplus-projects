import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/apps/core/widgets/app_icon_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_primary_button.dart';
import 'package:doctor_hunt/apps/core/widgets/app_text_field.dart';
import 'package:doctor_hunt/apps/features/patient/profile/presentation/controller/cubit/change_password_cubit.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ChangePasswordCubit>().changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: AppIconButton.back(
          onTap: () {
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(context.tr.changePassword, style: context.bold18TextMain),
      ),
      body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr.passwordChangedSuccess),
                backgroundColor: AppColors.primary,
              ),
            );
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          } else if (state is ChangePasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ChangePasswordSubmitting;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.currentPassword,
                      style: context.medium14TextMain,
                    ),
                    8.verticalSpace,
                    AppTextField(
                      key: const Key('current_password_input'),
                      controller: _currentPasswordController,
                      hintText: context.tr.currentPassword,
                      isPassword: true,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.tr.enterPassword;
                        }
                        return null;
                      },
                    ),
                    20.verticalSpace,
                    Text(
                      context.tr.newPassword,
                      style: context.medium14TextMain,
                    ),
                    8.verticalSpace,
                    AppTextField(
                      key: const Key('new_password_input'),
                      controller: _newPasswordController,
                      hintText: context.tr.newPassword,
                      isPassword: true,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.tr.enterPassword;
                        }
                        if (value.trim().length < 6) {
                          return context.tr.passwordMinLength;
                        }
                        return null;
                      },
                    ),
                    20.verticalSpace,
                    Text(
                      context.tr.confirmNewPassword,
                      style: context.medium14TextMain,
                    ),
                    8.verticalSpace,
                    AppTextField(
                      key: const Key('confirm_new_password_input'),
                      controller: _confirmPasswordController,
                      hintText: context.tr.confirmNewPassword,
                      isPassword: true,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.tr.enterPassword;
                        }
                        if (value != _newPasswordController.text) {
                          return context.tr.passwordsDoNotMatch;
                        }
                        return null;
                      },
                    ),
                    36.verticalSpace,
                    AppPrimaryButton(
                      key: const Key('change_password_submit_button'),
                      label: context.tr.changePassword,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _submit,
                    ),
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
