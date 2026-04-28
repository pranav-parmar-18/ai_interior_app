part of 'delete_account_bloc.dart';

class DeleteAccountRepository {
  CommonModelResponse? _makeSongResponse;

  CommonModelResponse? get makeSongResponse => _makeSongResponse;

  String _message = '';

  String get message => _message;
  bool? _success;

  bool? get success => _success;

  Future<void> deleteVideo() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String accessToken = preferences.getString('access_token') ?? "";
      const String url = '${ProjectConstant.baseUrl}account/delete';

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
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
