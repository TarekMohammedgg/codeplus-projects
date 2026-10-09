import 'package:flutter/material.dart';
import 'package:doctor_hunt/apps/core/theme/app_theme.dart';
import 'package:doctor_hunt/generated/i18n/translations.g.dart';
import 'package:doctor_hunt/generated/style_atoms.dart';

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.textInputAction = TextInputAction.search,
    this.prefixIcon,
    this.suffixIcon,
    this.height = 52,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
  });

  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputAction textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double height;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;

  @override
  State<AppSearchBar> createState() => AppSearchBarState();
}

class AppSearchBarState extends State<AppSearchBar> {
  TextEditingController? internalController;
  FocusNode? internalFocusNode;

  TextEditingController get effectiveController =>
      widget.controller ?? (internalController ??= TextEditingController());

  FocusNode? get effectiveFocusNode {
    if (widget.focusNode != null) return widget.focusNode;
    if (widget.readOnly) {
      return internalFocusNode ??= FocusNode(canRequestFocus: false);
    }
    return null;
  }

  @override
  void didUpdateWidget(covariant AppSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null) {
      internalController = TextEditingController(
        text: oldWidget.controller?.text,
      );
    } else if (widget.controller != null && oldWidget.controller == null) {
      internalController?.dispose();
      internalController = null;
    }
    if (!widget.readOnly && internalFocusNode != null) {
      internalFocusNode?.dispose();
      internalFocusNode = null;
    }
  }

  @override
  void dispose() {
    internalController?.dispose();
    internalFocusNode?.dispose();
    super.dispose();
  }

  void handleClear() {
    effectiveController.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final hint = widget.hintText ?? tr.searchDoctorHint;


    Widget searchBar = SearchBar(
      controller: effectiveController,
      focusNode: effectiveFocusNode,
      readOnly: widget.readOnly,
      autoFocus: widget.autofocus,
      onTap: widget.onTap,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      textInputAction: widget.textInputAction,
      hintText: hint,
      hintStyle: WidgetStatePropertyAll(
        context.regular14TextSecondary.copyWith(
          color: AppColors.textSecondary.withValues(alpha: 0.7),
        ),
      ),
      textStyle: WidgetStatePropertyAll(context.medium14TextMain),
      backgroundColor: WidgetStatePropertyAll(
        widget.backgroundColor ?? AppColors.surface,
      ),
      elevation: const WidgetStatePropertyAll(0),
      side: const WidgetStatePropertyAll(BorderSide.none),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(14),
        ),
      ),
      constraints: BoxConstraints(
        minHeight: widget.height,
        maxHeight: widget.height,
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 12),
      ),
      leading:
          widget.prefixIcon ??
          const Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary,
            size: 22,
          ),
      trailing: [
        if (widget.suffixIcon != null)
          widget.suffixIcon!
        else
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: effectiveController,
            builder: (context, value, _) {
              return Visibility(
                visible: value.text.isNotEmpty,
                child: IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: handleClear,
                ),
              );
            },
          ),
      ],
    );

    if (widget.readOnly) {
      searchBar = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: IgnorePointer(child: searchBar),
      );
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow:
            widget.boxShadow ??
            const [
              BoxShadow(
                //CR hardcode color
                // Solved
                color: AppColors.shadowElevated,
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
      ),
      child: searchBar,
    );
  }
}
