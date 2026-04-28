part of 'get_people_message_details_bloc.dart';

class GetPeopleMessageDetailsRepository {
  GetAiMessageDetailsResponse? _makeSongResponse;

  GetAiMessageDetailsResponse? get makeSongResponse => _makeSongResponse;

  String _message = '';

  String get message => _message;
  bool? _success;

  bool? get success => _success;

  Future<void> explore(String id) async {
    try {
       String url = '${ProjectConstant.baseUrl}people_message/details?other_user_id=$id';

      final response = await http.get(Uri.parse(url));
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");
      if (response.statusCode == 200) {
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = GetAiMessageDetailsResponse.fromJson(responseJsonMap);
        _makeSongResponse = responseData;
        _message = "Success";
        _success = true;
      } else {
        if (kDebugMode) {
          print("API FAILED : ${response.body}");
        }
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = GetAiMessageDetailsResponse.fromJson(responseJsonMap);
        _makeSongResponse = responseData;
        _message = "Fail";
        _success = false;
      }
    } catch (error) {
      if (kDebugMode) {
        print("GetPeopleMessageDetails API Exception : $error");
      }
      _message = 'Something went wrong!';
      rethrow;
    }
  }
}
