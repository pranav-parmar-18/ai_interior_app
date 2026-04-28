part of 'get_character_bloc.dart';

class GetCharacterRepository {
  CharacterResponse? _makeSongResponse;

  CharacterResponse? get makeSongResponse => _makeSongResponse;

  String _message = '';

  String get message => _message;
  bool? _success;

  bool? get success => _success;

  Future<void> getCharacter(String id) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String accessToken = preferences.getString('access_token') ?? "";
       String url = '${ProjectConstant.baseUrl}character/get?id=$id';

      final response = await http.get(Uri.parse(url),headers: {
        'Authorization': 'Bearer $accessToken'

      });
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");
      if (response.statusCode == 200) {
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = CharacterResponse.fromJson(responseJsonMap);
        _makeSongResponse = responseData;
        _message = "Success";
        _success = true;
      } else {
        if (kDebugMode) {
          print("API FAILED : ${response.body}");
        }
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = CharacterResponse.fromJson(responseJsonMap);
        _makeSongResponse = responseData;
        _message = "Fail";
        _success = false;
      }
    } catch (error) {
      if (kDebugMode) {
        print("GetCharacter API Exception : $error");
      }
      _message = 'Something went wrong!';
      rethrow;
    }
  }
}
