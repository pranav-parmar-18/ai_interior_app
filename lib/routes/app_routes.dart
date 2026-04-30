import 'package:ai_interior/features/onboarding/presentation/first_onboarding_screen.dart';
import 'package:ai_interior/features/splash/presentation/splash_screen.dart';
import 'package:flutter/cupertino.dart';

import '../features/chat/presentation/AI_chat_screen.dart';
import '../features/chat/presentation/call_screen.dart';
import '../features/chat/presentation/invite_screen.dart';
import '../features/chat/presentation/people_chat_screen.dart';
import '../features/chat/presentation/photos_screen.dart';
import '../features/credit/presentataion/credit_screen.dart';
import '../features/explore/presentation/match_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/interior/presentation/interior_list_screen.dart';
import '../features/interior/presentation/interior_plaate.dart';
import '../features/interior/presentation/interior_screen.dart';
import '../features/main/presentaion/main_screen.dart';

import '../features/onboarding/presentation/second_onboarding_screen.dart';
import '../features/onboarding/presentation/third_onboarding_screen.dart';
import '../features/profile/presentation/edit_photo.dart';
import '../features/profile/presentation/edit_profile_screen.dart';
import '../features/replace/presentation/replace_screen.dart';
import '../features/setting/presentation/setting_screens.dart';
import '../features/subscription/presentation/subscription_screen.dart';
import '../features/subscription/presentation/subscription_screen_three.dart';
import '../features/vision/presentation/vision_screen.dart';


class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => MainScreen(),
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

      case CreditScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => CreditScreen(),
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

      case SubscriptionThreeScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => SubscriptionThreeScreen(),
        );
      default:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => OnBoardingFirstScreen(),
        );
    }
    return null;
  }
}
