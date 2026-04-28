import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum ImageType { svg, png, network, file, unknown }

class CustomImageview extends StatelessWidget {
  final String? imagePath;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final String? placeHolder;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final BoxBorder? border;


  const CustomImageview({
    this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = "assets/images/image_not_found",

  });

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(alignment: alignment!, child: _buildWidget())
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(onTap: onTap, child: _buildCircleImage()),
    );
  }

  _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(border: border, borderRadius: radius),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (imagePath == null) return SizedBox();

    if (imagePath!.endsWith('.svg')) {
      return SvgPicture.asset(
        imagePath!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.contain,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
      );
    }
    if (imagePath!.startsWith('http') || imagePath!.startsWith('https')) {
      return CachedNetworkImage(
        imageUrl: imagePath!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
        errorWidget: (context, url, error) => placeHolder != null
            ? Image.asset(
          placeHolder!,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
        )
            : Icon(Icons.error),
      );
    }
    if (imagePath!.endsWith('.png') || imagePath!.endsWith('.jpg') || imagePath!.endsWith('.jpeg')) {
      return Image.asset(
        imagePath!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
      );
    }
    if (File(imagePath!).existsSync()) {
      return Image.file(
        File(imagePath!),
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
      );
    }

    return SizedBox();
  }

}
