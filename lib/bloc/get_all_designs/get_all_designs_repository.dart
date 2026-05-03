part of 'get_all_designs_bloc.dart';

class GetAllInteriorDesignRepository {
  GetAllInteriorDesignModelResponse? _makeSongResponse;

  GetAllInteriorDesignModelResponse? get makeSongResponse => _makeSongResponse;

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

  Future<void> getAllInteriorDesign(Map<String, dynamic> data) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String accessToken = preferences.getString('access_token') ?? "";

      const String url = '${ProjectConstant.baseUrl}interior/all';
      String jsonPayload = jsonEncode(data);
      String verifyHeader = generateVerifyHeader('');

      final response = await http.get(
        Uri.parse(url),
        headers: {'verify': verifyHeader},
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = GetAllInteriorDesignModelResponse.fromJson(
          responseJsonMap,
        );
        _makeSongResponse = responseData;
        _message = "Success";
        _success = true;
      } else {
        if (kDebugMode) {
          print("API FAILED : ${response.body}");
        }
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = GetAllInteriorDesignModelResponse.fromJson(
          responseJsonMap,
        );
        _makeSongResponse = responseData;
        _message = "Fail";
        _success = false;
      }
    } catch (error) {
      if (kDebugMode) {
        print("GetAllInteriorDesign API Exception : $error");
      }
      _message = 'Something went wrong!';
      rethrow;
    }
  }
}
