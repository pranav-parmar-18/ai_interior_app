part of 'send_ai_message_from_gf_bloc.dart';

class SendAIMessageFromGFRepository {
  CommonModelResponse? _makeSongResponse;

  CommonModelResponse? get makeSongResponse => _makeSongResponse;

  String _message = '';

  String get message => _message;
  bool? _success;

  bool? get success => _success;

  Future<void> SendAIMessageFromGF(Map<String, dynamic> data) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String accessToken = preferences.getString('access_token') ?? "";
      const String url = '${ProjectConstant.baseUrl}aimessage/fromaigf';
      String jsonPayload = jsonEncode(data);
      print("DATA : ${data}");
      final response = await http.post(
        Uri.parse(url),
        body: jsonPayload,
        headers: {'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = CommonModelResponse.fromJson(responseJsonMap);
        _makeSongResponse = responseData;
        _message = "Success";
        _success = true;
      } else {
        if (kDebugMode) {
          print("API FAILED : ${response.body}");
        }
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = CommonModelResponse.fromJson(responseJsonMap);
        _makeSongResponse = responseData;
        _message = "Fail";
        _success = false;
      }
    } catch (error) {
      _message = 'Something went wrong!';
      rethrow;
    }
  }
}
