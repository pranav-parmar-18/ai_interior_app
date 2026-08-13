import 'package:ai_interior/features/onboarding/presentation/first_onboarding_screen.dart';
import 'package:ai_interior/features/splash/presentation/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import '../features/credit/presentataion/credit_screen.dart';
import '../features/dream/presentation/dream_ash_list_screen.dart';
import '../features/dream/presentation/dream_output_screen.dart';
import '../features/dream/presentation/dream_plaate.dart';
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
import '../features/recents/presentation/recents_output_screen.dart';
import '../features/replace/presentation/replace_describe_me.dart';
import '../features/replace/presentation/replace_edit_screen.dart';
import '../features/replace/presentation/replace_output_screen.dart';
import '../features/replace/presentation/replace_screen.dart';
import '../features/setting/presentation/contact_screen.dart';
import '../features/setting/presentation/language_screen.dart';
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
import '../features/subscription/presentation/subscription_screen.dart';
import '../features/subscription/presentation/subscription_screen_three.dart';
import '../features/subscription/presentation/subscription_screen_two.dart';

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
      case SubscriptionScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => SubscriptionScreen(),
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
          builder: (_) => InteriorOutputScreen(),
        );
      case StyleTransferScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => StyleTransferScreen(),
        );
      case StyleOutputScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => InteriorOutputScreen(),
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
          builder: (_) => InteriorOutputScreen(),
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
      case DreamAshSelectionScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => DreamAshSelectionScreen(),
        );
      case DreamColorPaletteScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => DreamColorPaletteScreen(),
        );
      case ReplaceEditScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => ReplaceEditScreen(),
        );
      case ReplaceDescribeVisionScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => ReplaceDescribeVisionScreen(),
        );
      case ReplaceOutputScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => InteriorOutputScreen(),
        );
      case LanguageScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => LanguageScreen(),
        );
      case ContactUsScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => const ContactUsScreen(),
        );
      case DreamOutputScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => InteriorOutputScreen(),
        );

      case SubscriptionScreenTwo.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => SubscriptionScreenTwo(),
        );
      case SubscriptionScreenThree.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => SubscriptionScreenThree(),
        );
      case RecentOutputScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => InteriorOutputScreen(),
        );
      default:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => OnBoardingFirstScreen(),
        );
    }
  }
}
