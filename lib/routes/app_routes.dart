import 'package:ai_interior/features/onboarding/presentation/first_onboarding_screen.dart';
import 'package:ai_interior/features/splash/presentation/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import '../features/chat/presentation/call_screen.dart';
import '../features/chat/presentation/invite_screen.dart';
import '../features/credit/presentataion/credit_screen.dart';
import '../features/explore/presentation/explore_detail_screen.dart';
import '../features/exterior/presentation/exterior_list_screen.dart';
import '../features/exterior/presentation/exterior_screen.dart';
import '../features/interior/presentation/interior_ash_list_screen.dart';
import '../features/interior/presentation/interior_describe_me.dart';
import '../features/interior/presentation/interior_list_screen.dart';
import '../features/interior/presentation/interior_output_screen.dart';
import '../features/interior/presentation/interior_plaate.dart';
import '../features/interior/presentation/interior_screen.dart';
import '../features/main/presentaion/main_screen.dart';
import '../features/onboarding/presentation/fourth_onboarding_screen.dart';
import '../features/onboarding/presentation/second_onboarding_screen.dart';
import '../features/onboarding/presentation/third_onboarding_screen.dart';
import '../features/setting/presentation/setting_screens.dart';
import '../features/snap_trip/presentation/snap_trip_screen.dart';
import '../features/subscription/presentation/subscription_screen_three.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => SplashScreen(),
        );
      case OnBoardingFirstScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => OnBoardingFirstScreen(),
        );
      case OnboardingScreenTwo.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => OnboardingScreenTwo(),
        );
      case OnboardingScreenThree.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => OnboardingScreenThree(),
        );
      case CreditsScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => CreditsScreen(),
        );
      case MainScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => MainScreen(),
        );
      case InviteScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => InviteScreen(),
        );
      case CallScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => CallScreen(),
        );
      case ExploreResultScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => ExploreResultScreen(),
        );
      case ExteriorDesignScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => ExteriorDesignScreen(),
        );
      case InteriorDesignScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => InteriorDesignScreen(),
        );
      case SnapTipsScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => SnapTipsScreen(),
        );
      case RoomSelectionScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => RoomSelectionScreen(),
        );
      case InteriorAshSelectionScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => InteriorAshSelectionScreen(),
        );
      case InteriorColorPaletteScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => InteriorColorPaletteScreen(),
        );
      case InteriorOutputScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => InteriorOutputScreen(),
        );
      case InteriorRoomSelectionScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => InteriorRoomSelectionScreen(),
        );
      case SubscriptionThreeScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => SubscriptionThreeScreen(),
        );
      case OnboardingFourScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => OnboardingFourScreen(),
        );case SettingsScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => SettingsScreen(),
        );
      case InteriorDescribeVisionScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => InteriorDescribeVisionScreen(),
        );
      default:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => OnBoardingFirstScreen(),
        );
    }
  }
}
