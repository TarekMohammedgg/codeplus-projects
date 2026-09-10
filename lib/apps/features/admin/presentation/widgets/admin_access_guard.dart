import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/router/routes.dart';
import 'package:doctor_hunt/apps/features/common/auth/data/service/auth_service.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';

class AdminAccessGuard extends StatefulWidget {
  const AdminAccessGuard({required this.child, this.permission, super.key});

  final Widget child;
  final String? permission;

  @override
  State<AdminAccessGuard> createState() => _AdminAccessGuardState();
}

class _AdminAccessGuardState extends State<AdminAccessGuard> {
  final _authService = AuthService();
  bool? _isAllowed;

  @override
  void initState() {
    super.initState();
    _checkAccess();
  }

  Future<void> _checkAccess() async {
    try {
      final isAllowed = widget.permission == null
          ? await _authService.isCurrentUserAdmin()
          : await _authService.hasAdminPermission(widget.permission!);
      if (!mounted) return;
      if (!isAllowed) {
        const AdminLoginRoute().go(context);
        return;
      }
      setState(() => _isAllowed = true);
    } catch (_) {
      if (!mounted) return;
      const AdminLoginRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAllowed != true) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return widget.child;
  }
}
