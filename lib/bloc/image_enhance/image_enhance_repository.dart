part of 'image_enhance_bloc.dart';

class ImageEnhanceRepository {
  ImageEnhanceResponse? _makeSongResponse;

  ImageEnhanceResponse? get makeSongResponse => _makeSongResponse;

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

  Future<void> login(Map<String, dynamic> data) async {
    try {
      const String url = '${ProjectConstant.baseUrl}image-enhance';
      String jsonPayload = jsonEncode(data);
      final verifyHeader = generateVerifyHeader('');

      final response = await http.post(
        Uri.parse(url),
        body: jsonPayload,
        headers: {
          'Content-Type': 'application/json',
          'verify': verifyHeader, // <-- IMPORTANT

        },
      );

      if (response.statusCode == 200) {
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = ImageEnhanceResponse.fromJson(responseJsonMap);
        print("LOGIN Response: ${response.body}");
        _makeSongResponse = responseData;
        if (responseJsonMap.containsKey('error') && responseJsonMap['error'] != null) {
          _message = responseJsonMap['error'].toString();
          _success = false;
        } else if (responseData.data?.errors != null && responseData.data!.errors!.isNotEmpty) {
          _message = responseData.data!.errors!.join(', ');
          _success = false;
        } else if (responseData.data?.name == "payment_required") {
          _message = "Payment required: Insufficient Stability AI credits on server.";
          _success = false;
        } else if (responseData.status != true || responseData.data?.id == null || responseData.data!.id!.isEmpty) {
          _message = responseData.message ?? "Failed to initiate image enhancement task.";
          _success = false;
        } else {
          _message = "Success";
          _success = true;
        }
      } else {
        if (kDebugMode) {
          print("API FAILED : ${response.body}");
        }
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = ImageEnhanceResponse.fromJson(responseJsonMap);
        _makeSongResponse = responseData;
        _message = responseData.message ?? "Fail";
        _success = false;
      }
    } catch (error) {
      _message = 'Something went wrong!';
      rethrow;
    }
  }
}
