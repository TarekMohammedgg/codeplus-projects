import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';

enum SnackBarStatus { success, error, warning, info }

extension CustomSnackBarExtension on BuildContext {
  /// Displays a floating snackbar with custom styling based on [status].
  void showCustomSnackBar({
    required String message,
    String? title,
    SnackBarStatus status = SnackBarStatus.info,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final (Color primaryColor, Color bgColor, IconData icon) = switch (status) {
      SnackBarStatus.success => (
        AppColors.success,
        AppColors.successLight,
        Icons.check_circle_rounded,
      ),
      SnackBarStatus.error => (
        AppColors.error,
        AppColors.errorLight,
        Icons.error_rounded,
      ),
      SnackBarStatus.warning => (
        AppColors.warning,
        AppColors.warningLight,
        Icons.warning_amber_rounded,
      ),
      SnackBarStatus.info => (
        AppColors.primaryGreen,
        AppColors.softMint,
        Icons.info_outline_rounded,
      ),
    };

    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        duration: duration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: primaryColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null && title.isNotEmpty) ...[
                      Text(
                        title,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(
                      message,
                      style: const TextStyle(
                        color: AppColors.textMain,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: Text(
                    actionLabel,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Convenience shortcut for success snackbar.
  void showSuccessSnackBar(String message, {String? title}) =>
      showCustomSnackBar(
        message: message,
        title: title,
        status: SnackBarStatus.success,
      );

  /// Convenience shortcut for error snackbar.
  void showErrorSnackBar(String message, {String? title}) => showCustomSnackBar(
    message: message,
    title: title,
    status: SnackBarStatus.error,
  );

  /// Convenience shortcut for warning snackbar.
  void showWarningSnackBar(String message, {String? title}) =>
      showCustomSnackBar(
        message: message,
        title: title,
        status: SnackBarStatus.warning,
      );

  /// Convenience shortcut for info snackbar.
  void showInfoSnackBar(String message, {String? title}) => showCustomSnackBar(
    message: message,
    title: title,
    status: SnackBarStatus.info,
  );
}
