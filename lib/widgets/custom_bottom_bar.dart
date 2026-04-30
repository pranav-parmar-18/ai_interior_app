import 'package:ai_interior/features/main/presentaion/main_screen.dart';
import 'package:ai_interior/widgets/custom_imageview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/theme.dart';

enum BottomBarEnum { Home, Explore, Recents }

// class CustomBottomBar extends StatefulWidget {
//   CustomBottomBar({super.key, this.onChanged, required this.selectedTab,});
//
//   Function(BottomBarEnum)? onChanged;
//   final BottomBarEnum selectedTab;
//   @override
//   State<CustomBottomBar> createState() => _CustomBottomBarState();
// }
//
// class _CustomBottomBarState extends State<CustomBottomBar> {
//   int selectedIndex = 0;
//
//   List<BottomMenuModel> bottomMenuList = [
//     BottomMenuModel(
//       icon: "assets/images/bottom_one.svg",
//       activeIcon: "assets/images/bottom_five.png",
//       type: BottomBarEnum.Aimusic,
//       title: "Ai Music",
//     ),
//     BottomMenuModel(
//       icon: "assets/images/bottom_six.png",
//       activeIcon: "assets/images/bottom_two.svg",
//       type: BottomBarEnum.Trending,
//       title: "Trending",
//     ),
//     BottomMenuModel(
//       icon: "assets/images/bottom_three.svg",
//       activeIcon: "assets/images/bottom_four.png",
//       type: BottomBarEnum.MySongs,
//       title: "My Songs",
//     ),
//   ];
//   @override
//   void didUpdateWidget(covariant CustomBottomBar oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // Rebuild UI when selectedTab is updated from parent
//     if (widget.selectedTab != oldWidget.selectedTab) {
//       setState(() {});
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color.fromRGBO(0, 0, 0, 1),
//         border: Border(
//           top: BorderSide(
//             color: theme.colorScheme.errorContainer,
//             width: 0.5,
//           ),
//         ),
//       ),
//       child: BottomNavigationBar(
//         backgroundColor: Color.fromRGBO(0, 0, 0, 1),
//         showSelectedLabels: false,
//         showUnselectedLabels: false,
//         selectedFontSize: 0,
//         elevation: 3,
//         items: List.generate(bottomMenuList.length, (index) {
//           bool isSelected = selectedIndex == index;
//           return BottomNavigationBarItem(
//             icon: SizedBox(
//               width: 60,
//               height: 70,
//               child: Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     CustomImageview(
//                       imagePath: isSelected
//                           ? bottomMenuList[index].activeIcon
//                           : bottomMenuList[index].icon,
//                       height: isSelected ? 21 : 20,
//                       width: isSelected ? 23 : 22,
//                     ),
//                     const SizedBox(height: 5),
//                 isSelected
//                     ? Text(
//                   bottomMenuList[index].title ?? "",
//                   overflow: TextOverflow.ellipsis,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 11.16,
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w500,
//                     foreground: Paint()
//                       ..shader = LinearGradient(
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                         colors: [
//                           Color.fromRGBO(178, 124, 218, 1), // Purple
//                           Color.fromRGBO(168, 115, 255, 1), // Purple
//                         ],
//                         stops: [0.0, 0.5], // Gradient from left to right
//                       ).createShader(
//                         Rect.fromLTWH(0, 0, 300, 0), // 300 width ensures visible split
//                       ),
//                   ),
//                 )
//                     : Text(
//                   bottomMenuList[index].title ?? "",
//                   overflow: TextOverflow.ellipsis,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: appTheme.whiteA700,
//                     fontSize: 11.16,
//                     fontFamily: 'Poppins',
//                     fontWeight: FontWeight.w500,
//                   ),
//                 )
//
//                 ],
//                 ),
//               ),
//             ),
//             label: '',
//           );
//         }),
//         currentIndex: selectedIndex,
//         onTap: (value) {
//           setState(() {
//             selectedIndex = value;
//           });
//           widget.onChanged?.call(bottomMenuList[value].type);
//         },
//       ),
//     );
//   }
// }

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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        // border: Border(
        //   top: BorderSide(color: Colors.white, width: 2),
        // ),
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
              width: isIPad(context) ? 85 : 60,
              height: isIPad(context) ? 110 : 70,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomImageview(
                      imagePath: isSelected ? item.activeIcon : item.icon,
                      height:
                          isSelected
                              ? isIPad(context)
                                  ? 50
                                  : 33
                              : isIPad(context)
                              ? 45
                              : 30,
                      width:
                          isSelected
                              ? isIPad(context)
                                  ? 50
                                  : 30
                              : isIPad(context)
                              ? 45
                              : 25,
                      fit: BoxFit.contain,
                      color:
                          isSelected
                              ? Color.fromRGBO(50, 116, 127, 1)
                              : Color.fromRGBO(168, 168, 168, 1),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.title ?? "",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style:
                          isSelected
                              ? TextStyle(
                                fontSize: isIPad(context) ? 30 : 15.16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(50, 116, 127, 1),
                              )
                              : TextStyle(
                                color: Color.fromRGBO(168, 168, 168, 1),
                                fontSize: isIPad(context) ? 25 : 11.16,
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
