import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/credit/presentataion/credit_screen.dart';
import '../features/subscription/presentation/subscription_screen.dart';
import '../features/subscription/presentation/subscription_screen_two.dart';
import '../features/subscription/presentation/subscription_screen_three.dart';
import 'user_credit_service.dart';

class SubscriptionScreenManager {
  static final SubscriptionScreenManager _instance = SubscriptionScreenManager._internal();
  factory SubscriptionScreenManager() => _instance;
  SubscriptionScreenManager._internal();

  int _currentIndex = 0;

  /// Total subscription screens you have
  final int totalScreens = 3;

  /// Get next subscription screen index
  int getNextIndex() {
    int index = _currentIndex;
    _currentIndex = (_currentIndex + 1) % totalScreens;
    return index;
  }

  /// Checks if the user has an active subscription.
  static Future<bool> isUserSubscribed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_subscribed') ?? false;
  }

  /// Opens the next subscription screen in the rotation.
  /// Returns `true` if the user is subscribed (purchased, restored, or active).
  static Future<bool> openSubscriptionScreen(BuildContext context) async {
    final nextIndex = SubscriptionScreenManager().getNextIndex();

    final screens = [
      const SubscriptionScreen(),
      const SubscriptionScreenTwo(),
      const SubscriptionScreenThree(),
    ];

    final result = await Navigator.push<bool>(
      context,
      CupertinoPageRoute(builder: (_) => screens[nextIndex]),
    );

    // Sync latest credits in case subscription grants credits
    await UserCreditService.fetchLatestCredits();

    final isSubscribed = await isUserSubscribed();
    return (result == true) || isSubscribed;
  }

  /// Opens CreditsScreen if user has active subscription, otherwise opens SubscriptionScreen.
  static Future<void> openCreditOrSubscriptionScreen(BuildContext context) async {
    final isSubscribed = await isUserSubscribed();
    if (!context.mounted) return;

    if (isSubscribed) {
      await Navigator.of(context).pushNamed(CreditsScreen.routeName);
      await UserCreditService.fetchLatestCredits();
    } else {
      await openSubscriptionScreen(context);
    }
  }
}
