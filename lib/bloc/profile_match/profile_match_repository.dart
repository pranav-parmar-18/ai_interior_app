part of 'profile_match_bloc.dart';

class ProfileMatchRepository {
  ProfileMatchResponse? _makeSongResponse;

  ProfileMatchResponse? get makeSongResponse => _makeSongResponse;

  String _message = '';

  String get message => _message;
  bool? _success;

  bool? get success => _success;

  Future<void> ProfileMatch(Map<String, dynamic> data) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String accessToken = preferences.getString('access_token') ?? "";
      const String url = '${ProjectConstant.baseUrl}profile/match';
      String jsonPayload = jsonEncode(data);

      final response = await http.post(
        Uri.parse(url),
        body: jsonPayload,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = ProfileMatchResponse.fromJson(responseJsonMap);
        print("Profile Match Success: ${response.body}");

        _makeSongResponse = responseData;

        if (_makeSongResponse!.status == true &&
            _makeSongResponse!.message == "Profile Matched") {
          _message = "Success";
          _success = true;
        } else {
          _message = "Fail";
          _success = false;
        }
      } else {
        if (kDebugMode) {
          print("API FAILED : ${response.body}");
        }
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = ProfileMatchResponse.fromJson(responseJsonMap);
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
