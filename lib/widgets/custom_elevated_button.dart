import 'dart:io';

import 'package:ai_interior/theme/theme.dart';
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

  bool isIPad(BuildContext context) {
    return Platform.isIOS &&
        MediaQuery.of(context).size.shortestSide >= 600;
  }

  Widget  buildElevatedButtonWidget (BuildContext context) {
    return Container(
      height: this.height ?? 60,
      width: this.width ?? double.maxFinite,
      margin: margin,
      decoration:
      decoration ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(138, 35, 135, 1),
                Color.fromRGBO(233, 64, 87, 1),
                Color.fromRGBO(242, 113, 33, 1),
              ],
            ),
          ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Make button transparent
          shadowColor: Colors.transparent, // Remove shadow effect
          surfaceTintColor: Colors.transparent, // Fix for Material 3
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
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
                    fontSize: isIPad(context) ?30 :22,
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w800,
                  ),
            ),
            rightIcon ?? const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
