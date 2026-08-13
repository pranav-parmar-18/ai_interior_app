part of 'contact_us_bloc.dart';

class ContactUsRepository {
  CommonModelResponse? _makeSongResponse;
  CommonModelResponse? get makeSongResponse => _makeSongResponse;

  String _message = '';

  String get message => _message;
  bool? _success;

  bool? get success => _success;

  static const String SECRET_KEY = '1';
  static const int PRIME_NUMBER = 14010449171989;

  String simpleHash(String input) {
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      hash = (hash << 1) - hash + input.codeUnitAt(i);
    }
    return hash.abs().toRadixString(16);
  }

  String generateVerifyHeader(String payload) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String stringToHash = timestamp + payload + SECRET_KEY;
    String stringToHashBase64 = base64.encode(utf8.encode(stringToHash));
    String hashValue = simpleHash(stringToHashBase64);

    int computedHash = (int.parse(hashValue, radix: 16) ~/ 100) * PRIME_NUMBER;
    String headerValue = base64.encode(utf8.encode("${computedHash.toRadixString(16)}:$timestamp"));

    return headerValue;
  }

  Future<void> contactUs(Map<String, dynamic> data, File? pngFile) async {
    try {
      const String url = 'https://tm-contact.pickleballify.com/api/contact';

      var request = http.MultipartRequest('POST', Uri.parse(url));

      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (pngFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            pngFile.path,
          ),
        );
      }

      // Convert fields to JSON for verify header
      String jsonPayload = jsonEncode(data);
      String verifyHeader = generateVerifyHeader(jsonPayload);

      request.headers.addAll({
        'verify': verifyHeader,
        // NO need for Content-Type; MultipartRequest sets it automatically
      });

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);


      if (response.statusCode == 200) {
        final map = jsonDecode(response.body) as Map<String, dynamic>;
        print("SUCCESS :  ${response.body}");
        print("SUCCESS :  ${response.statusCode}");
        final result = CommonModelResponse.fromJson(map);

        _makeSongResponse = result;
        _message = "Success";
        _success = true;
      } else {
        final map = jsonDecode(response.body) as Map<String, dynamic>;
        print("FAIL :  ${response.body}");

        final result = CommonModelResponse.fromJson(map);
        _makeSongResponse = result;
        _message = "Fail";
        _success = false;
      }
    } catch (e) {
      _message = "Something went wrong!";
      rethrow;
    }
  }
}
