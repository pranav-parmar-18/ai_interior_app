part of 'explore_bloc.dart';

class ExploreRepository {
  ExploreModelResponse? _makeSongResponse;

  ExploreModelResponse? get makeSongResponse => _makeSongResponse;

  String _message = '';

  String get message => _message;
  bool? _success;

  bool? get success => _success;

  Future<void> explore() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String accessToken = preferences.getString('access_token') ?? "";
      int characterType = preferences.getInt('char_type') ?? 0;
      int gender = preferences.getInt('gender_type') ?? 0;

      print("GENDER TYPE: $gender");
      print("CHARACTER TYPE: $characterType");

      String url;
      if (characterType != 0 && gender != 0) {
        url =
            '${ProjectConstant.baseUrl}explore/list?page=1&limit=100&character_type=$characterType&gender=$gender';
      } else if (gender != 0) {
        url =
            '${ProjectConstant.baseUrl}explore/list?page=1&limit=100&gender=$gender';
      } else if (characterType != 0) {
        url =
            '${ProjectConstant.baseUrl}explore/list?page=1&limit=100&character_type=$characterType';
      } else {
        url = '${ProjectConstant.baseUrl}explore/list?page=1&limit=100';
      }
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      print("EXPLORE URL : $url");
      final response = await http.get(Uri.parse(url), headers: headers);

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");
      if (response.statusCode == 200) {
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = ExploreModelResponse.fromJson(responseJsonMap);
        _makeSongResponse = responseData;
        _message = "Success";
        _success = true;
      } else {
        if (kDebugMode) {
          print("API FAILED : ${response.body}");
        }
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = ExploreModelResponse.fromJson(responseJsonMap);
        _makeSongResponse = responseData;
        _message = "Fail";
        _success = false;
      }
    } catch (error) {
      if (kDebugMode) {
        print("Explore API Exception : $error");
      }
      _message = 'Something went wrong!';
      rethrow;
    }
  }
}
