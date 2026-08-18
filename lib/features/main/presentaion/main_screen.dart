import 'dart:io';
import 'package:ai_interior/features/subscription/presentation/subscription_screen.dart';
import 'package:ai_interior/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/user_credit_service.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/custom_bottom_bar.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../explore/presentation/explore_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../recents/presentation/recent_screen.dart';

class MainScreen extends StatefulWidget {

  final int initialIndex;

  static const routeName = "/main";
  const MainScreen({super.key,this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  final List<Widget> _screens = [];

  bool? isSubscribed;

  @override
  void initState() {
    super.initState();
    selectedIndex.value = widget.initialIndex;

    // isSubscriptionActive();
    _screens.addAll([
      HomeScreen(),
      ExploreScreen(),
      RecentsScreen(selectedIndex: selectedIndex),
    ]);
  }

  void _updateTab(int index) {
    setState(() {
      selectedIndex.value = index;
    });
  }

  void _onTabChanged(BottomBarEnum type) {
    if (type == BottomBarEnum.Home) {
      selectedIndex.value = 0;
      UserCreditService.fetchLatestCredits();
    } else if (type == BottomBarEnum.Explore) {
      selectedIndex.value = 1;
    } else if (type == BottomBarEnum.Recents) {
      selectedIndex.value = 2;
    }
  }

  Widget _buildBottomBar(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedIndex,
      builder: (context, index, child) {
        return CustomBottomBar(
          selectedTab: BottomBarEnum.values[index],
          onChanged: _onTabChanged,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(13, 13, 16, 1),
      extendBody: true,
      body: ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (context, index, child) {
          return IndexedStack(index: index, children: _screens);
        },
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  @override
  void dispose() {
    selectedIndex.dispose();
    super.dispose();
  }
}

/// Legacy helper — delegates to [ResponsiveUtils.isIPad].
/// Kept for backward compatibility during migration.
bool isIPad(BuildContext context) {
  return ResponsiveUtils.isIPad(context);
}

/// Legacy helper — delegates to [ResponsiveUtils.isSmallPhone].
bool isIPhoneMini(BuildContext context) {
  return ResponsiveUtils.isSmallPhone(context);
}

/// Legacy helper for iPhone SE detection.
bool isIPhoneSE(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final height = size.height;
  final width = size.width;
  final shortestSide = size.shortestSide;

  return Platform.isIOS &&
      shortestSide < 400 &&
      (
          (height == 667 && width == 375) || (height == 375 && width == 667) || // SE 2nd/3rd Gen
              (height == 568 && width == 320) || (height == 320 && width == 568)    // SE 1st Gen
      );
}

void showSnackSuccess(BuildContext context, String name) {
  CustomSnackBar.success(context, name);
}

void showSnackError(BuildContext context, String name) {
  CustomSnackBar.error(context, name);
}