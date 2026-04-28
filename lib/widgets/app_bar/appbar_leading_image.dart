
import 'package:flutter/material.dart';

import '../custom_imageview.dart';

class AppbarLeadingImage extends StatelessWidget {
  const AppbarLeadingImage({
    Key? key,
    this.imagePath,
    this.height,
    this.width,
    this.onTap,
    this.margin,
  }) : super(key: key);

  final double? height;
  final double? width;
  final String? imagePath;
  final Function? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: margin ?? EdgeInsets.zero, child: GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: CustomImageview(
        imagePath: imagePath!,
        height: height??24,width: width??12,
        fit: BoxFit.contain,
      ),
    ));
  }
}
