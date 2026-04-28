import 'package:ai_interior/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Alignment? alignment;
  final double? width;
  final BoxDecoration? boxDecoration;
  final TextEditingController? scrollPadding;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? autofocus;
  final TextStyle? textStyle;
  final bool? obscureText;
  final bool? readOnly;
  final VoidCallback? onTap;
  final VoidCallback? onChange;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final int? maxLines;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final Widget? suffix;

  final InputBorder? borderDecoration;
  final Color? fillCOlor;
  final bool? filled;
  final FormFieldValidator<String>? validator;
  final BoxConstraints? suffixConstraints;
  final BoxConstraints? preFixConstraints;
  final EdgeInsets? contentPadding;

  const CustomTextFormField({
    super.key,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textStyle,
    this.focusNode,
    this.boxDecoration,
    this.alignment,
    this.width,
    this.autofocus,
    this.borderDecoration,
    this.controller,
    this.fillCOlor,
    this.filled,
    this.hintText,
    this.maxLines,
    this.obscureText,
    this.onTap,
    this.onChange,
    this.prefix,
    this.readOnly,
    this.scrollPadding,

    this.hintStyle,
    this.validator,
    this.suffix,
    this.preFixConstraints,
    this.contentPadding,
    this.suffixConstraints
  });

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
          alignment: alignment ?? Alignment.center,
          child: textFormFieldWidget(context),
        )
        : textFormFieldWidget(context);
  }

  Widget textFormFieldWidget(BuildContext context) => Container(
    width: width ?? double.maxFinite,
    decoration: boxDecoration,
    child: TextFormField(
      scrollPadding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      controller: controller,
      focusNode: focusNode,
      onTapUpOutside: (event) {
        if (focusNode != null) {
          focusNode?.unfocus();
        } else {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      autofocus: true,
      style:
          textStyle ??
          TextStyle(
            color: theme.colorScheme.onError,
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
      obscureText: false,
      readOnly: false,
      onTap: () {
        onTap?.call();
      },
      onChanged: (value) {
        onChange?.call();
      },
      textInputAction: textInputAction,
      keyboardType: textInputType,
      maxLines: maxLines ?? 1,
      decoration: decoration,
      validator: validator,
    ),
  );

  InputDecoration get decoration => InputDecoration(
    hintText: hintText ?? "",
    hintStyle:
        hintStyle ??
        TextStyle(
          color: theme.colorScheme.onError,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
    prefixIcon: prefix,
    suffix: suffix,
    isDense: true,
    contentPadding: contentPadding ?? EdgeInsets.all(16),
    prefixIconConstraints: preFixConstraints,
    suffixIconConstraints: suffixConstraints,
    border:
        borderDecoration ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: theme.colorScheme.errorContainer.withValues(alpha: 1),
            width: 1,
          ),
        ),
    enabledBorder:
        borderDecoration ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: theme.colorScheme.errorContainer.withValues(alpha: 1),
            width: 1,
          ),
        ),
    focusedBorder:
        borderDecoration ??
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 1),
            width: 1,
          ),
        ),
  );
}
