import 'package:ai_interior/features/main/presentaion/main_screen.dart';
import 'package:ai_interior/utils/responsive_utils.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/theme.dart';

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
        title: "Resents",
      ),
    ];

    int selectedIndex = bottomMenuList.indexWhere(
      (element) => element.type == selectedTab,
    );

    // Responsive sizes
    final containerWidth = r.adaptiveValue(context, mobile: 60, tablet: 85);
    final containerHeight = r.adaptiveValue(context, mobile: 70, tablet: 100);
    final selectedIconSize = r.adaptiveValue(context, mobile: 33, tablet: 44);
    final unselectedIconSize = r.adaptiveValue(context, mobile: 30, tablet: 40);
    final selectedIconWidth = r.adaptiveValue(context, mobile: 30, tablet: 40);
    final unselectedIconWidth = r.adaptiveValue(context, mobile: 25, tablet: 35);
    final selectedFontSize = r.sp(context, 15);
    final unselectedFontSize = r.sp(context, 11);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(r.wp(context, 15)),
          topRight: Radius.circular(r.wp(context, 15)),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        elevation: 0,
        items: List.generate(bottomMenuList.length, (index) {
          bool isSelected = selectedIndex == index;
          final item = bottomMenuList[index];
          return BottomNavigationBarItem(
            icon: SizedBox(
              width: containerWidth,
              height: containerHeight,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomImageview(
                      imagePath: isSelected ? item.activeIcon : item.icon,
                      height: isSelected ? selectedIconSize : unselectedIconSize,
                      width: isSelected ? selectedIconWidth : unselectedIconWidth,
                      fit: BoxFit.contain,
                      color:
                          isSelected
                              ? Color.fromRGBO(50, 116, 127, 1)
                              : Color.fromRGBO(168, 168, 168, 1),
                    ),
                    SizedBox(height: r.hp(context, 5)),
                    Text(
                      item.title ?? "",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style:
                          isSelected
                              ? TextStyle(
                                fontSize: selectedFontSize,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(50, 116, 127, 1),
                              )
                              : TextStyle(
                                color: Color.fromRGBO(168, 168, 168, 1),
                                fontSize: unselectedFontSize,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ],
                ),
              ),
            ),
            label: '',
          );
        }),
        onTap: (index) {
          HapticFeedback.lightImpact();
          onChanged?.call(bottomMenuList[index].type);
        },
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
