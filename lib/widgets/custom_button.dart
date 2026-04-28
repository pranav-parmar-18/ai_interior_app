import 'package:ai_interior/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    this.alignment,
    this.height,
    this.width,
    this.decoration,
    this.padding,
    this.onTap,
    this.child,
  });
  final Alignment? alignment;
  final double? height;
  final double? width;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
          alignment: alignment ?? Alignment.center,
          child: iconButtonWidget,
        )
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => SizedBox(
    height: height ?? 0,
    width: width ?? 0,
    child: DecoratedBox(
      decoration:
          decoration ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: appTheme.whiteA700, width: 1),
            gradient: LinearGradient(
              begin: Alignment(0.5, 0),
              end: Alignment(0.5, 1),
              colors: [appTheme.deepPurple300],
            ),
          ),
      child: IconButton(
        onPressed: onTap,
        icon: child ?? Container(),
        padding: padding ?? EdgeInsets.zero,
      ),
    ),
  );
}
