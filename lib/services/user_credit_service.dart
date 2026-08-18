import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../features/home/presentation/home_screen.dart';
import '../utils/app_utils.dart';
import 'device_indentification_service.dart';

class UserCreditService {
  /// Fetches the latest credit balance and user ID from the backend API,
  /// updates [creditsNotifier.value] and persists to [SharedPreferences].
  static Future<String?> fetchLatestCredits() async {
    try {
      final deviceId = await DeviceIdManager.getDeviceId();
      if (deviceId.isEmpty) return null;

      const String url = '${ProjectConstant.baseUrl}user/create';
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({"uuid": deviceId}),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final dynamic rawCredits = data['credits'];
        final dynamic userData = data['data'];

        final credits = (rawCredits ?? 0).toString();
        final userId = userData != null && userData['id'] != null
            ? userData['id'].toString()
            : "";

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('credits', credits);
        if (userId.isNotEmpty) {
          await prefs.setString('user_id', userId);
        }

        creditsNotifier.value = credits;
        debugPrint("✅ Latest credits synced from API: $credits (user_id: $userId)");
        return credits;
      } else {
        debugPrint("⚠️ Failed to sync credits: status ${response.statusCode} - ${response.body}");
      }
    } catch (e, stack) {
      debugPrint("❌ Exception syncing credits from API: $e\n$stack");
    }
    return null;
  }
}
