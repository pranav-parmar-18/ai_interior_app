import 'package:ai_interior/features/onboarding/presentation/first_onboarding_screen.dart';
import 'package:ai_interior/features/splash/presentation/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import '../features/chat/presentation/call_screen.dart';
import '../features/chat/presentation/invite_screen.dart';
import '../features/credit/presentataion/credit_screen.dart';
import '../features/dream/presentation/dream_screen.dart';
import '../features/explore/presentation/explore_detail_screen.dart';

import '../features/exterior/presentation/exterior_ash_list_screen.dart';
import '../features/exterior/presentation/exterior_describe_me.dart';
import '../features/exterior/presentation/exterior_list_screen.dart';
import '../features/exterior/presentation/exterior_output_screen.dart';
import '../features/exterior/presentation/exterior_plaate.dart';
import '../features/exterior/presentation/exterior_screen.dart';
import '../features/interior/presentation/interior_ash_list_screen.dart';
import '../features/interior/presentation/interior_describe_me.dart';
import '../features/interior/presentation/interior_list_screen.dart';
import '../features/interior/presentation/interior_output_screen.dart';
import '../features/interior/presentation/interior_plaate.dart';
import '../features/interior/presentation/interior_screen.dart';
import '../features/main/presentaion/main_screen.dart';
import '../features/onboarding/presentation/fourth_onboarding_screen.dart';

import '../features/replace/presentation/replace_screen.dart';
import '../features/setting/presentation/setting_screens.dart';
import '../features/snap_trip/presentation/snap_trip_screen.dart';
import '../features/staging/presentation/staging_ash_list_screen.dart';
import '../features/staging/presentation/staging_describe_me.dart';
import '../features/staging/presentation/staging_list_screen.dart';
import '../features/staging/presentation/staging_output_screen.dart';
import '../features/staging/presentation/staging_plaate.dart';
import '../features/staging/presentation/staging_screen.dart';
import '../features/style_transfer/presentation/style_output_screen.dart';
import '../features/style_transfer/presentation/style_transfer_screeen.dart';
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
        );
      case SettingsScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => SettingsScreen(),
        );
      case InteriorDescribeVisionScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => InteriorDescribeVisionScreen(),
        );
      case ExteriorDesignScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => ExteriorDesignScreen(),
        );
      case ExteriorRoomSelectionScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => ExteriorRoomSelectionScreen(),
        );
      case ExteriorAshSelectionScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => ExteriorAshSelectionScreen(),
        );
      case ExteriorDescribeVisionScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => ExteriorDescribeVisionScreen(),
        );
      case ExteriorColorPaletteScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => ExteriorColorPaletteScreen(),
        );

      case ExteriorOutputScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => ExteriorOutputScreen(),
        );
      case StyleTransferScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => StyleTransferScreen(),
        );
      case StyleOutputScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => StyleOutputScreen(),
        );
      case StagingDesignScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => StagingDesignScreen(),
        );
      case StagingRoomSelectionScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => StagingRoomSelectionScreen(),
        );
      case StagingAshSelectionScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => StagingAshSelectionScreen(),
        );
      case StagingDescribeVisionScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => StagingDescribeVisionScreen(),
        );

      case StagingColorPaletteScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => StagingColorPaletteScreen(),
        );
      case StagingOutputScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => StagingOutputScreen(),
        );
      case ReplaceScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => ReplaceScreen(),
        );
      case DreamSpaceScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => DreamSpaceScreen(),
        );
      default:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => OnBoardingFirstScreen(),
        );
    }
  }
}
