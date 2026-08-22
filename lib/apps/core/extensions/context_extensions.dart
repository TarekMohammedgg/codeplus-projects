import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  void unfocus() => FocusScope.of(this).unfocus();
}
