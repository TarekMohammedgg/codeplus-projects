import 'package:flutter/material.dart';

import 'package:medora/generated/app_strings.dart';
import 'package:medora/generated/app_styles.dart';

class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double height;
  final double fontSize;
  final IconData? icon;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 64,
    this.fontSize = 18,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyles.primaryBlue,
          disabledBackgroundColor: AppStyles.disabled,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: fontSize + 3, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(label),
                ],
              )
            : Text(label),
      ),
    );
  }
}

class GoogleAuthButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GoogleAuthButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppStyles.navy,
          side: const BorderSide(color: AppStyles.primaryBlue, width: 1.35),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(17)),
          ),
          textStyle: const TextStyle(
            color: AppStyles.navy,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GoogleMark(),
            SizedBox(width: 18),
            Text(AppStrings.continueWithGoogle),
          ],
        ),
      ),
    );
  }
}

class GoogleMark extends StatelessWidget {
  const GoogleMark({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'G',
      style: TextStyle(
        color: Color(0xFF4285F4),
        fontSize: 31,
        fontWeight: FontWeight.w700,
        height: 1,
      ),
    );
  }
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppStyles.outline)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            AppStrings.or,
            style: AppStyles.body.copyWith(
              color: AppStyles.textSecondary,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppStyles.outline)),
      ],
    );
  }
}
