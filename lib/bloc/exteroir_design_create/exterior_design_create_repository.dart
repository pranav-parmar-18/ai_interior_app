part of 'exterior_design_create_bloc.dart';

class ExteriorDeignCreateRepository {
  ExteriorDesignCreateModelResponse? _makeSongResponse;

  ExteriorDesignCreateModelResponse? get makeSongResponse => _makeSongResponse;

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

  String buildPayload(Map<String, dynamic> data) {
    return jsonEncode({
      "user_id": data['user_id'],
      "colors": data['colors'],
      "design_asthetic": data['design_asthetic'],
      "space_type": data['space_type'],
    });
  }

  Future<void> exteriorDesignCreate(
    Map<String, dynamic> data,
    File image,
  ) async {
    try {
      final uri = Uri.parse('${ProjectConstant.baseUrl}exterior/create');

      final verifyHeader = generateVerifyHeader('');

      final request = http.MultipartRequest('POST', uri);

      // 🔹 Headers
      request.headers.addAll({
        'verify': verifyHeader, // <-- IMPORTANT
      });

      // 🔹 Form fields
      request.fields['user_id'] = data['user_id'].toString();
      request.fields['colors'] = data['colors'];
      request.fields['design_asthetic'] = data['design_asthetic'];
      request.fields['space_type'] = data['space_type'];

      // 🔹 Image
      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      // 🔹 Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

        _makeSongResponse = ExteriorDesignCreateModelResponse.fromJson(
          responseJson,
        );
        _message = "Success";
        _success = true;

        if (kDebugMode) {
          print("SUCCESS: ${response.body}");
        }
      } else {
        if (kDebugMode) {
          print("FAILED: ${response.body}");
        }
        _success = false;
      }
    } catch (e) {
      _message = 'Something went wrong!';
      rethrow;
    }
  }
}
