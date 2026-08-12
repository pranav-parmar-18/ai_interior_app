part of 'smart_replace_create_bloc.dart';

class SmartReplaceCreateRepository {
  SmartReplaceCreateModelResponse? _makeSongResponse;

  SmartReplaceCreateModelResponse? get makeSongResponse => _makeSongResponse;

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

  Future<void> smartReplaceCreate(
    Map<String, dynamic> data,
    File image,
    File mask,
  ) async {
    try {
      final uri = Uri.parse('${ProjectConstant.baseUrl}smart-replace/create');

      final verifyHeader = generateVerifyHeader('');

      final request = http.MultipartRequest('POST', uri);

      // 🔹 Headers
      request.headers.addAll({
        'verify': verifyHeader,
      });

      // 🔹 Form fields
      request.fields['user_id'] = data['user_id'].toString();
      request.fields['prompt'] = data['prompt'];

      // 🔹 Files
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      request.files.add(await http.MultipartFile.fromPath('mask', mask.path));

      // 🔹 Send request with extended timeout (AI image generation takes 50+ seconds)
      final client = http.Client();
      final http.Response response;
      try {
        final streamedResponse = await client.send(request).timeout(
          const Duration(minutes: 3),
        );
        response = await http.Response.fromStream(streamedResponse);
      } finally {
        client.close();
      }

      print("URL: $uri");
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

        if (responseJson['status'] == true || responseJson['status'] == 200 || responseJson['status']?.toString() == '200' || responseJson['status']?.toString() == 'true') {
          _makeSongResponse = SmartReplaceCreateModelResponse.fromJson(responseJson);
          _message = "Success";
          _success = true;
        } else {
          _message = responseJson['message']?.toString() ?? "Failed";
          _success = false;
        }
      } else {
        _message = 'Failed to replace object';
        _success = false;
      }
    } catch (e) {
      _message = 'Something went wrong!';
      rethrow;
    }
  }
}

