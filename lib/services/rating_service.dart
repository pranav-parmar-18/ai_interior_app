import 'dart:async';
import 'package:ai_interior/services/remote_config_services.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingManager {
  RatingManager._privateConstructor();
  static final RatingManager _instance = RatingManager._privateConstructor();
  static RatingManager get instance => _instance;

  bool isEnableRating = false;
  int ratingDuration = 1;
  int ratingDisplayTotalTime = 1;
  int timerCount = 0;
  int showCount = 0;

  Timer? _timer;
  final String _ratedKey = "hasUserRated";

  /// Call this once when the app starts
  Future<void> start() async {
    try {
      debugPrint("🟡 RatingManager: start() called");

      final prefs = await SharedPreferences.getInstance();
      final hasRated = prefs.getBool(_ratedKey) ?? false;
      debugPrint("📌 hasUserRated: $hasRated");

      if (hasRated) {
        debugPrint("🛑 Exiting: user already rated.");
        return;
      }

      final remoteConfigService = RemoteConfigService();
      final ratingConfig = await remoteConfigService.fetchRatingConfig();
      debugPrint("📥 Remote config fetched: $ratingConfig");

      if (!ratingConfig.isEnable) {
        debugPrint("🚫 Rating is disabled in Remote Config");
        return;
      }

      isEnableRating = ratingConfig.isEnable;
      ratingDuration = ratingConfig.ratingDisplayTime;
      ratingDisplayTotalTime = ratingConfig.ratingDisplayCount;

      debugPrint("✅ Starting timer with $ratingDuration sec & $ratingDisplayTotalTime max shows");
      startTimer();
    } catch (e) {
      debugPrint("❌ RatingManager.start error: $e");
    }
  }


  // Future<void> start() async {
  //   debugPrint("🟡 Force-starting timer for test");
  //   isEnableRating = true;
  //   ratingDuration = 5;
  //   ratingDisplayTotalTime = 3;
  //   startTimer();
  // }
  void startTimer() {
    stopTimer();

    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) async {
      if (!isEnableRating) {
        stopTimer();
        return;
      }

      timerCount += 1;
      debugPrint("⏱ Timer Count: $timerCount");

      if (timerCount >= ratingDuration && showCount < ratingDisplayTotalTime) {
        timerCount = 0;
        showCount += 1;
        debugPrint("⭐️ Showing rating #$showCount");
        await showRating();
      }

      if (showCount >= ratingDisplayTotalTime) {
        // Call markUserAsRated when the rating dialog has been shown the max number of times
        await markUserAsRated();
        stopTimer();
      }
    });
  }

  Future<void> showRating() async {
    final InAppReview inAppReview = InAppReview.instance;

    try {
      // Check if the review is available
      if (await inAppReview.isAvailable()) {
        // Request review dialog
        await inAppReview.requestReview();

        // Wait for a moment to see if user rated or dismissed (simulate that process)
        await Future.delayed(Duration(seconds: 2));

        // Check if user rated (we can't know directly, so we assume they did if we show the review)
        if (await inAppReview.isAvailable()) {
          // This assumes review was shown, but not "Not Now" button.
          if (showCount < ratingDisplayTotalTime) {
            // resetTimerAfterRatingDuration();
          } else {
            debugPrint("🚫 Rating dialog reached max display count: $ratingDisplayTotalTime.");
          }

        } else {
          // If they dismissed or skipped the review, restart the timer after ratingDuration.
          await markUserAsRated();
          stopTimer();
        }
      } else {
        debugPrint("❌ In-App Review not available.");
      }
    } catch (e) {
      debugPrint("❌ Error showing review: $e");
    }
  }

  void resetTimerAfterRatingDuration() {
    // Reset the timer after `ratingDuration`
    Future.delayed(Duration(seconds: ratingDuration), () {
      debugPrint("🔄 Retrying to show rating after $ratingDuration seconds...");
      startTimer();
    });
  }

  Future<void> markUserAsRated() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_ratedKey, true);
    isEnableRating = false;
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    timerCount = 0;
    showCount = 0;
  }
}
