import 'package:flutter/widgets.dart';

import 'package:doctor_hunt/apps/core/errors/app_exception.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';

extension AppErrorCodeText on AppErrorCode {
  String localized(Translations t) => switch (this) {
    AppErrorCode.userNotFound => t.userNotFoundError,
    AppErrorCode.wrongPassword => t.wrongPasswordError,
    AppErrorCode.wrongCurrentPassword => t.wrongCurrentPassword,
    AppErrorCode.emailAlreadyInUse => t.emailAlreadyInUseError,
    AppErrorCode.invalidEmail => t.invalidEmailError,
    AppErrorCode.weakPassword => t.weakPasswordError,
    AppErrorCode.userDisabled => t.userDisabledError,
    AppErrorCode.tooManyRequests => t.tooManyRequestsError,
    AppErrorCode.networkRequestFailed => t.networkRequestFailedError,
    AppErrorCode.accountExistsWithDifferentCredential =>
      t.accountExistsWithDifferentCredentialError,
    AppErrorCode.operationNotAllowed => t.operationNotAllowedError,
    AppErrorCode.requiresRecentLogin => t.requiresRecentLogin,
    AppErrorCode.googleSignInConfig => t.googleSignInConfigError,
    AppErrorCode.googleSignInInterrupted => t.googleSignInInterruptedError,
    AppErrorCode.googleSignInFailed => t.googleSignInFailedError,
    AppErrorCode.adminPermissionDenied => t.adminPermissionDenied,
    AppErrorCode.uploadImage => t.uploadImageError,
    AppErrorCode.alreadyReviewed => t.alreadyReviewed,
    AppErrorCode.appointmentNotCompleted => t.appointmentNotCompleted,
    AppErrorCode.ratingRequired => t.selectRatingRequired,
    AppErrorCode.service => t.serviceError,
    AppErrorCode.unexpected => t.unexpectedError,
  };
}

extension AppErrorContext on BuildContext {
  /// Localized text for any error thrown by the data layer.
  String errorText(Object error) =>
      AppException.from(error).code.localized(this.tr);
}
