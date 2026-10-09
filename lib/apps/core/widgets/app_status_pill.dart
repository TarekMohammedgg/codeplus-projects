import 'package:flutter/material.dart';

import 'package:doctor_hunt/apps/core/extensions/num_extensions.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

/// Small rounded status label with a leading dot (appointment status,
/// doctor active/inactive).
class AppStatusPill extends StatelessWidget {
  const AppStatusPill({
    super.key,
    required this.label,
    required this.color,
    required this.backgroundColor,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
  });

  final String label;
  final Color color;
  final Color backgroundColor;

  /// Color is always [color]; defaults to the 9pt medium label.
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 3, backgroundColor: color),
          5.horizontalSpace,
          Text(
            label,
            style: (textStyle ?? context.medium10TextMain.copyWith(fontSize: 9))
                .copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
