import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();

  factory RemoteConfigService() {
    return _instance;
  }

  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<int> fetchMusicCount() async {
    try {
      // ✅ SAFELY Set Defaults

      // ✅ Config settings
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: Duration(seconds: 10),
          minimumFetchInterval: Duration(seconds: 0),
        ),
      );

      // ✅ Fetch & Activate
      final isActivated = await _remoteConfig.fetchAndActivate();
      print('🎯 fetchAndActivate: $isActivated');

      // ✅ Safe parsing
      final value = _remoteConfig.getValue('music_count');
      print('📦 Raw music_count value: ${value.asString()}');

      final count = int.tryParse(value.asString()) ?? 0;
      print('🎵 Parsed music_count: $count');

      return count;
    } catch (e, stackTrace) {
      print('❌ Remote Config fetch failed: $e');
      print('Stack trace: $stackTrace');
      return 1;
    }
  }

  Future<RatingConfig> fetchRatingConfig() async {
    try {
      // Optional: fetch & activate if not done elsewhere
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: Duration(seconds: 10),
          minimumFetchInterval: Duration(seconds: 0),
        ),
      );

      final isActivated = await _remoteConfig.fetchAndActivate();
      print('🎯 fetchAndActivate (Rating): $isActivated');

      final jsonString = _remoteConfig.getString('Rating');
      print('📦 Raw Rating value: $jsonString');

      final jsonMap = json.decode(jsonString);
      final ratingConfig = RatingConfig.fromJson(jsonMap);

      print('✅ Parsed Rating config: $ratingConfig');

      return ratingConfig;
    } catch (e, stackTrace) {
      print('❌ Failed to fetch Rating config: $e');
      print('Stack trace: $stackTrace');

      // Return default fallback
      return RatingConfig(
        isEnable: false,
        ratingDisplayCount: 5,
        ratingDisplayTime: 5,
      );
    }
  }

  Future<SubscriptionConfig> fetchSubscriptionConfig() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: Duration(seconds: 15),
          minimumFetchInterval: Duration(seconds: 0),
        ),
      );

      final isActivated = await _remoteConfig.fetchAndActivate();
      print('🎯 fetchAndActivate (Subscription): $isActivated');

      final jsonString = _remoteConfig.getString('Subscription');
      print('📦 Raw Subscription value: $jsonString');

      final jsonMap = json.decode(jsonString);
      final config = SubscriptionConfig.fromJson(jsonMap);

      print('✅ Parsed Subscription config: $config');
      return config;
    } catch (e, stackTrace) {
      print('❌ Failed to fetch Subscription config: $e');
      print('Stack trace: $stackTrace');
      return SubscriptionConfig(
        screenOne: true,
        screenTwo: true,
        screenThree: true,
        screenOrder: [
          "subscription_screen_one",
          "subscription_screen_two",
          "subscription_screen_three",
        ],
      );
    }
  }
}

class RatingConfig {
  final bool isEnable;
  final int ratingDisplayCount;
  final int ratingDisplayTime;

  RatingConfig({
    required this.isEnable,
    required this.ratingDisplayCount,
    required this.ratingDisplayTime,
  });

  factory RatingConfig.fromJson(Map<String, dynamic> json) {
    return RatingConfig(
      isEnable: json['isEnable'] ?? false,
      ratingDisplayCount: json['ratingDisplayCount'] ?? 5,
      ratingDisplayTime: json['ratingDisplayTime'] ?? 5,
    );
  }
}

class SubscriptionConfig {
  final bool screenOne;
  final bool screenTwo;
  final bool screenThree;
  final List<String> screenOrder;

  SubscriptionConfig({
    required this.screenOne,
    required this.screenTwo,
    required this.screenThree,
    required this.screenOrder,
  });

  factory SubscriptionConfig.fromJson(Map<String, dynamic> json) {
    return SubscriptionConfig(
      screenOne: json['subscription_screen_one'] ?? false,
      screenTwo: json['subscription_screen_two'] ?? false,
      screenThree: json['subscription_screen_three'] ?? false,
      screenOrder: List<String>.from(json['screen_order'] ?? []),
    );
  }
}
