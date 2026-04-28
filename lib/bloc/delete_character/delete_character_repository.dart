part of 'delete_character_bloc.dart';

class DeleteCharacterRepository {
  CommonModelResponse? _makeSongResponse;

  CommonModelResponse? get makeSongResponse => _makeSongResponse;

  String _message = '';

  String get message => _message;
  bool? _success;

  bool? get success => _success;

  Future<void> deleteCharacter(String id) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String accessToken = preferences.getString('access_token') ?? "";
       String url = '${ProjectConstant.baseUrl}character/delete?id=$id';

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      var request = http.Request('DELETE', Uri.parse(url));


      request.headers.addAll(headers);
      http.StreamedResponse streamedResponse = await request.send();
      final responseString = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        final responseJsonMap =
            jsonDecode(responseString) as Map<String, dynamic>;
        final responseData = CommonModelResponse.fromJson(responseJsonMap);
        _makeSongResponse = responseData;
        _message = "Success";
        _success = true;
      } else {
        if (kDebugMode) {
          print("DELETE VIDEO FAILED : $responseString");
        }
        final responseJsonMap =
            jsonDecode(responseString) as Map<String, dynamic>;
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
