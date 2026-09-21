import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/apps/core/router/routes.dart';

extension AuthNavigation on BuildContext {
  /// Goes back when there is a previous page, otherwise opens the login page.
  void popOrGoToLogin() {
    if (canPop()) {
      pop();
    } else {
      const LoginRoute().go(this);
    }
  }
}
