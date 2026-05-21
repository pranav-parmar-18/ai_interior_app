import 'package:ai_interior/theme/theme.dart';
import 'package:ai_interior/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final BoxDecoration? decoration;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final EdgeInsets? margin;
  final VoidCallback? onPressed;
  final ButtonStyle? buttonStyle;
  final Alignment? aligemnt;
  final TextStyle? buttonTextStyle;
  final bool? isDisabled;
  final double? height;
  final double? width;
  final String text;

  const CustomElevatedButton({
    super.key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    this.width,
    this.height,
    this.aligemnt,
    this.buttonStyle,
    this.buttonTextStyle,
    this.isDisabled,
    this.margin,
    this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return aligemnt != null
        ? Align(
          alignment: aligemnt ?? Alignment.center,
          child: buildElevatedButtonWidget(context),
        )
        : buildElevatedButtonWidget(context);
  }

  Widget buildElevatedButtonWidget(BuildContext context) {
    final defaultHeight = r.adaptiveValue(context, mobile: 60, tablet: 70);
    final borderRadius = r.wp(context, 30);
    final fontSize = r.sp(context, 22);

    return Container(
      height: this.height ?? defaultHeight,
      width: this.width ?? double.maxFinite,
      margin: margin,
      decoration:
          decoration ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 218, 179, 1),
                Color.fromRGBO(50, 116, 127, 1),
              ],
            ),
          ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: isDisabled ?? false ? null : onPressed ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leftIcon ?? const SizedBox.shrink(),
            Text(
              text,
              style:
                  buttonTextStyle ??
                  TextStyle(
                    color: appTheme.gray200,
                    fontSize: fontSize,
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w800,
                  ),
            ),
            rightIcon ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
