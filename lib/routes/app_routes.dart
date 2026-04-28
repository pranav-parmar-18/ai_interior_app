import 'package:ai_interior/features/onboarding/presentation/first_onboarding_screen.dart';
import 'package:ai_interior/features/splash/presentation/splash_screen.dart';
import 'package:ai_interior/features/user/presentation/user_data_screen_one.dart';
import 'package:flutter/cupertino.dart';

import '../features/chat/presentation/AI_chat_screen.dart';
import '../features/chat/presentation/call_screen.dart';
import '../features/chat/presentation/invite_screen.dart';
import '../features/chat/presentation/people_chat_screen.dart';
import '../features/chat/presentation/photos_screen.dart';
import '../features/credit/presentataion/credit_screen.dart';
import '../features/explore/presentation/match_screen.dart';
import '../features/main/presentaion/main_screen.dart';

import '../features/onboarding/presentation/second_onboarding_screen.dart';
import '../features/onboarding/presentation/third_onboarding_screen.dart';
import '../features/profile/presentation/edit_photo.dart';
import '../features/profile/presentation/edit_profile_screen.dart';
import '../features/setting/presentation/setting_screens.dart';
import '../features/subscription/presentation/subscription_screen_three.dart';
import '../features/user/presentation/user_data_screen_five.dart';
import '../features/user/presentation/user_data_screen_four.dart';
import '../features/user/presentation/user_data_screen_seven.dart';
import '../features/user/presentation/user_data_screen_six.dart';
import '../features/user/presentation/user_data_screen_three.dart';
import '../features/user/presentation/user_data_screen_two.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => OnBoardingFirstScreen(),
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
      case SettingScreens.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => SettingScreens(),
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

      case UserDataScreenOne.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => UserDataScreenOne(),
        );
      case UserDataScreenTwo.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => UserDataScreenTwo(),
        );
      case UserDataScreenThree.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => UserDataScreenThree(),
        );
      case UserDataScreenFour.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => UserDataScreenFour(),
        );
      case UserDataScreenFive.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => UserDataScreenFive(),
        );
      case UserDataScreenSix.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => UserDataScreenSix(),
        );
      case UserDataScreenSeven.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => UserDataScreenSeven(),
        );
      case EditProfileScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => EditProfileScreen(),
        );
      case EditPhotoScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => EditPhotoScreen(),
        );
      case InviteScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => InviteScreen(),
        );

      case MatchScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => MatchScreen(),
        );
      case AIChatScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => AIChatScreen(),
        );
      case CallScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => CallScreen(),
        );
      case PeopleChatScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => PeopleChatScreen(),
        );
      case PhotosScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => PhotosScreen(),
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
