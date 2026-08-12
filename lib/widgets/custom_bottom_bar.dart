import 'dart:ui' as ui;
import 'package:ai_interior/features/main/presentaion/main_screen.dart';
import 'package:ai_interior/utils/responsive_utils.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/theme.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

enum BottomBarEnum { Home, Explore, Recents }

class CustomBottomBar extends StatelessWidget {
  final BottomBarEnum selectedTab;
  final Function(BottomBarEnum)? onChanged;

  const CustomBottomBar({super.key, required this.selectedTab, this.onChanged});

  @override
  Widget build(BuildContext context) {

    List<BottomMenuModel> bottomMenuList = [
      BottomMenuModel(
        icon: "assets/images/home.png",
        activeIcon: "assets/images/home.png",
        type: BottomBarEnum.Home,
        title: "Home",
      ),
      BottomMenuModel(
        icon: "assets/images/explore.png",
        activeIcon: "assets/images/explore.png",
        type: BottomBarEnum.Explore,
        title: "Explore",
      ),
      BottomMenuModel(
        icon: "assets/images/recents.png",
        activeIcon: "assets/images/recents.png",
        type: BottomBarEnum.Recents,
        title: "Recents",
      ),
    ];

    int selectedIndex = bottomMenuList.indexWhere(
      (element) => element.type == selectedTab,
    );

    // Responsive sizes - scaled to fit cleanly within container
    final containerHeight = r.adaptiveValue(context, mobile: 68, tablet: 84);
    final selectedIconSize = r.adaptiveValue(context, mobile: 24, tablet: 32);
    final unselectedIconSize = r.adaptiveValue(context, mobile: 22, tablet: 30);
    final selectedIconWidth = r.adaptiveValue(context, mobile: 24, tablet: 32);
    final unselectedIconWidth = r.adaptiveValue(context, mobile: 22, tablet: 30);
    final selectedFontSize = r.sp(context, 11);
    final unselectedFontSize = r.sp(context, 11);

    final tabPillWidth = 102.0 * bottomMenuList.length;
    final horizontalPaddingVal = r.wp(context, 10);
    final barWidth = tabPillWidth + horizontalPaddingVal * 2;

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: barWidth,
        child: GlassTabBar.bottom(
          selectedIndex: selectedIndex,
          onTabSelected: (index) {
            HapticFeedback.lightImpact();
            onChanged?.call(bottomMenuList[index].type);
          },
          settings: LiquidGlassSettings(
            glassColor: const Color(0xFFE8E7E7).withOpacity(0.8),
            blur: 0.9,
          ),
          tabs: bottomMenuList.map((item) {
            return GlassTab(
              icon: CustomImageview(
                imagePath: item.icon,
                height: unselectedIconSize,
                width: unselectedIconWidth,
                fit: BoxFit.contain,
                color: Color.fromRGBO(89, 89, 89, 1.0), // Inactive tab color rgba(148, 148, 148, 1)
              ),
              activeIcon: CustomImageview(
                imagePath: item.activeIcon,
                height: selectedIconSize,
                width: selectedIconWidth,
                fit: BoxFit.contain,
                color: const Color.fromRGBO(50, 116, 127, 1), // Active tab color rgba(50, 116, 127, 1)
              ),
              label: item.title,
            );
          }).toList(),
          selectedLabelStyle: TextStyle(
            fontSize: selectedFontSize,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: unselectedFontSize,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
          selectedLabelColor: const Color.fromRGBO(50, 116, 127, 1),
          unselectedLabelColor: Color.fromRGBO(89, 89, 89, 1.0), // Inactive tab color rgba(148, 148, 148, 1)
          selectedIconColor: const Color.fromRGBO(50, 116, 127, 1),
          unselectedIconColor:Color.fromRGBO(89, 89, 89, 1.0), // Inactive tab color rgba(148, 148, 148, 1)
          barHeight: containerHeight,
          tabWidth: 102.0, // Scaled tab button width
          tabPadding: const EdgeInsets.only(top: 4, bottom: 4, left: 6, right: 6), // Padding from Figma specs
          iconLabelSpacing: 3.0, // gap: 3px
          horizontalPadding: horizontalPaddingVal, // Horizontal padding around the pill
          verticalPadding: r.hp(context, 10), // Vertical floating space
          magnification: 1.0,
          quality: GlassQuality.standard,
          glowOpacity: 0.05,
          glowBlurRadius: 8,
          glowSpreadRadius: 1,
          indicatorColor: const Color(0xFFE2DDD5), // light grey/beige indicator from mockup
          indicatorBorderRadius: 24,
          indicatorExpansion: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        ),
      ),
    );
  }
}

class BottomMenuModel {
  String icon;
  String activeIcon;
  String? title;
  BottomBarEnum type;

  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    this.title,
    required this.type,
  });
}
