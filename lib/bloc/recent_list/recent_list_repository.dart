part of 'recent_list_bloc.dart';

class RecentListRepository {
  RecentListModelResponse? _makeSongResponse;

  RecentListModelResponse? get makeSongResponse => _makeSongResponse;

  String _message = '';

  String get message => _message;
  bool? _success;

  bool? get success => _success;

  static const String SECRET_KEY = '1';
  static const int PRIME_NUMBER = 14010449171989;

  String simpleHash(String input) {
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      hash = ((hash << 1) - hash + input.codeUnitAt(i)) & 0xFFFFFFFF;
    }
    return hash.abs().toRadixString(16);
  }

  String generateVerifyHeader(String payload) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String stringToHash = timestamp + payload + SECRET_KEY;
    String stringToHashBase64 = base64.encode(utf8.encode(stringToHash));
    String hashValue = simpleHash(stringToHashBase64);

    int computedHash = (int.parse(hashValue, radix: 16) ~/ 100) * PRIME_NUMBER;
    String headerValue = base64.encode(
      utf8.encode("${computedHash.toRadixString(16)}:$timestamp"),
    );

    return headerValue;
  }

  Future<void> recentList(Map<String, dynamic> data) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String accessToken = preferences.getString('access_token') ?? "";

      final uri = Uri.parse('${ProjectConstant.baseUrl}recent-list').replace(
        queryParameters: data.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      final verifyHeader = generateVerifyHeader('');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'verify': verifyHeader,
        },
      );

      print("URL: $uri");
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        _makeSongResponse = RecentListModelResponse.fromJson(responseJsonMap);
        _message = "Success";
        _success = true;
      } else {
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        _makeSongResponse = RecentListModelResponse.fromJson(responseJsonMap);
        _message = "Fail";
        _success = false;
      }
    } catch (error) {
      if (kDebugMode) {
        print("Recent List API Exception: $error");
      }
      _message = 'Something went wrong!';
      rethrow;
    }
  }
}
