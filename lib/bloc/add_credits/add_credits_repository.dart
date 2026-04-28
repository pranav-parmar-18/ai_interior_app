part of 'add_credits_bloc.dart';

class AddCreditsRepository {
  AddCreditResponse? _makeSongResponse;

  AddCreditResponse? get makeSongResponse => _makeSongResponse;

  String _message = '';

  String get message => _message;
  bool? _success;

  bool? get success => _success;

  Future<void> addCredit(Map<String, dynamic> data) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String accessToken = preferences.getString('access_token') ?? "";

      const String url = '${ProjectConstant.baseUrl}add/credit';
      String jsonPayload = jsonEncode(data);

      print("DATA : ${data}");

      final response = await http.post(
        Uri.parse(url),
        body: jsonPayload,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );

      if (response.statusCode == 200) {
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        print("API SUCCESS : ${response.body}");
        final responseData = AddCreditResponse.fromJson(responseJsonMap);
        _makeSongResponse = responseData;
        if(_makeSongResponse!.status==true){
          print("STATUS : ${_makeSongResponse!.status}");
          _message = "Success";
          _success = true;
        }else{
          _message = "Fail";
          _success = false;
        }

      } else {
        if (kDebugMode) {
          print("API FAILED : ${response.body}");
        }
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = AddCreditResponse.fromJson(responseJsonMap);
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
