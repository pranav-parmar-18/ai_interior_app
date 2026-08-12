part of 'get_enhancment_response_api_bloc.dart';

class GerEnhancmentResponseRepository {
  ImageEnhanceModelResponse? _makeSongResponse;

  ImageEnhanceModelResponse? get makeSongResponse => _makeSongResponse;

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

  Future<void> getEnhancementList(Map<String, dynamic> data) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String accessToken = preferences.getString('access_token') ?? "";
      final uri = Uri.parse('${ProjectConstant.baseUrl}check-enhancement-status').replace(
        queryParameters: data.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      final verifyHeader = generateVerifyHeader('');

      int maxRetries = 15;
      for (int attempt = 0; attempt < maxRetries; attempt++) {
        final response = await http.get(uri, headers: {
          'Authorization': 'Bearer $accessToken',
          'verify': verifyHeader,
        });

        if (kDebugMode) {
          print("STATUS: ${response.statusCode}");
          print("BODY: ${response.body}");
        }

        if (response.statusCode == 200) {
          final responseJsonMap =
              jsonDecode(response.body) as Map<String, dynamic>;
          final responseData = ImageEnhanceModelResponse.fromJson(responseJsonMap);
          final outputImageUrl = responseData.imageUrl?.outputImage ?? '';

          if (outputImageUrl.isNotEmpty) {
            try {
              final freshUrl = "$outputImageUrl?t=${DateTime.now().millisecondsSinceEpoch}";
              final imgRes = await http.get(Uri.parse(freshUrl));

              if (imgRes.statusCode == 200 && imgRes.bodyBytes.length > 5000) {
                _makeSongResponse = ImageEnhanceModelResponse(
                  success: responseData.success,
                  imageUrl: ImageUrl(
                    id: responseData.imageUrl?.id,
                    userId: responseData.imageUrl?.userId,
                    prompt: responseData.imageUrl?.prompt,
                    spaceType: responseData.imageUrl?.spaceType,
                    jobId: responseData.imageUrl?.jobId,
                    outputImage: freshUrl,
                    status: responseData.imageUrl?.status,
                    createdAt: responseData.imageUrl?.createdAt,
                    updatedAt: responseData.imageUrl?.updatedAt,
                  ),
                );
                _message = "Success";
                _success = true;
                return;
              }
            } catch (_) {}
          }
        } else {
          final responseJsonMap =
              jsonDecode(response.body) as Map<String, dynamic>;
          final responseData = ImageEnhanceModelResponse.fromJson(responseJsonMap);
          _makeSongResponse = responseData;
          if (responseJsonMap.containsKey('error')) {
            final err = responseJsonMap['error'];
            if (err is Map && err.containsKey('task_id')) {
              _message = (err['task_id'] is List)
                  ? (err['task_id'] as List).join(', ')
                  : err['task_id'].toString();
            } else {
              _message = err.toString();
            }
          } else if (responseJsonMap.containsKey('message')) {
            _message = responseJsonMap['message'].toString();
          } else {
            _message = "Fail";
          }
          _success = false;
          return;
        }

        await Future.delayed(const Duration(seconds: 3));
      }

      _message = "Enhancement timed out. Please try again.";
      _success = false;
    } catch (error) {
      if (kDebugMode) {
        print("Ger EnhancmentResponse API Exception : $error");
      }
      _message = 'Something went wrong!';
      rethrow;
    }
  }
}
