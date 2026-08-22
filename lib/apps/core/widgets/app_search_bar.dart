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

  TextEditingController get effectiveController =>
      widget.controller ?? (internalController ??= TextEditingController());

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
  }

  @override
  void dispose() {
    internalController?.dispose();
    super.dispose();
  }

  void handleClear() {
    effectiveController.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final hint = widget.hintText ?? t.searchDoctorHint;

    // ==========================================
    // 1) الطريقة السابقة (Manual Container + TextField) - معطلة للتجربة
    // ==========================================
    /*
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.surface,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(14),
        boxShadow:
            widget.boxShadow ??
            const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
      ),
      child: TextField(
        controller: effectiveController,
        focusNode: widget.focusNode,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        textInputAction: widget.textInputAction,
        style: const TextStyle(
          color: AppColors.textMain,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          filled: false,
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.7),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon:
              widget.prefixIcon ??
              const Icon(
                Icons.search_rounded,
                color: AppColors.textSecondary,
                size: 22,
              ),
          suffixIcon:
              widget.suffixIcon ??
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
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
    */

    // ==========================================
    // 2) طريقة SearchBar المدمجة من Flutter (Material 3)
    // ==========================================
    return Container(
      decoration: BoxDecoration(
        boxShadow:
            widget.boxShadow ??
            const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
      ),
      child: SearchBar(
        controller: effectiveController,
        focusNode: widget.focusNode,
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
          context.regular14TextSub.copyWith(
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
      ),
    );
  }
}
