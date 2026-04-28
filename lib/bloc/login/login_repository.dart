part of 'login_bloc.dart';

class LoginRepository {
  LoginModelResponse? _makeSongResponse;

  LoginModelResponse? get makeSongResponse => _makeSongResponse;

  String _message = '';

  String get message => _message;
  bool? _success;

  bool? get success => _success;

  Future<void> login(Map<String, dynamic> data) async {
    try {
      const String url = '${ProjectConstant.baseUrl}login';
      String jsonPayload = jsonEncode(data);

      final response = await http.post(
        Uri.parse(url),
        body: jsonPayload,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = LoginModelResponse.fromJson(responseJsonMap);
        print("LOGIN Success: ${response.body}");
        _makeSongResponse = responseData;
        _message = "Success";
        _success = true;
      } else {
        if (kDebugMode) {
          print("API FAILED : ${response.body}");
        }
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = LoginModelResponse.fromJson(responseJsonMap);
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
