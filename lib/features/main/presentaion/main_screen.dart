import 'dart:io';
import 'package:ai_interior/features/subscription/presentation/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/custom_bottom_bar.dart';
import '../../home/presentation/home_screen.dart';

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

    isSubscriptionActive();
    _screens.addAll([
      HomeScreen(),
      HomeScreen(),
      HomeScreen(),
    ]);
  }

  void _updateTab(int index) {
    setState(() {
      selectedIndex.value = index;
    });
  }

  void _onTabChanged(BottomBarEnum type) {
    if (type == BottomBarEnum.Explore) {
      selectedIndex.value = 0;
    } else if (type == BottomBarEnum.Chat) {
      selectedIndex.value = 1;
    } else if (type == BottomBarEnum.Create) {
      selectedIndex.value = 2;
    } else if (type == BottomBarEnum.Profile) {
      selectedIndex.value = 3;
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
      body: ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (context, index, child) {
          return IndexedStack(index: index, children: _screens);
        },
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  // Future<void> getIsSubscribed() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.getBool('is_subscribed');
  // }

  @override
  void dispose() {
    selectedIndex.dispose();
    super.dispose();
  }

  Future<bool> isSubscriptionActive() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('subscription_info');
    if (data == null) {
      setState(() {
        isSubscribed = false;
      });
      return false;
    }

    final sub = SubscriptionInfo.fromJson(data);
    setState(() {
      isSubscribed = sub?.isActive ?? false;
    });

    return sub?.isActive ?? false;
  }
}


bool isIPad(BuildContext context) {
  return Platform.isIOS && MediaQuery.of(context).size.shortestSide >= 600;
}

bool isIPhoneMini(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final height = size.height;
  final width = size.width;
  final shortestSide = size.shortestSide;

  return Platform.isIOS &&
      shortestSide < 400 &&
      ((height == 812 && width == 375) || (height == 375 && width == 812));
}

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