
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final double? height;
  final ShapeBorder? shape;
  final double? leadingWidth;
  final Widget? leading;
  final Widget? title;
  final bool? centerTitle;
  final List<Widget>? actions;

  CustomAppBar({Key? key,this.height,this.shape,this.leadingWidth,this.leading,this.centerTitle,this.actions, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return AppBar(
      elevation: 0,
      shape: shape,
      toolbarHeight: height ?? 56,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      leadingWidth: leadingWidth ??0,
      leading: leading,
      title: title,
centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(
    double.maxFinite,
    height?? 56
  );


}