part of 'get_all_modules_bloc.dart';

class GetAllModulesRepository {
  List<AppModule>? _modulesList;

  List<AppModule>? get modulesList => _modulesList;

  String _message = '';

  String get message => _message;
  bool? _success;

  bool? get success => _success;

  Future<void> GetAllModules() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String accessToken = preferences.getString('access_token') ?? "";
      const String url = '${ProjectConstant.baseUrl}get-app-modules';

      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $accessToken',
      });
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");
      if (response.statusCode == 200) {
        final List<dynamic> responseJsonList =
            jsonDecode(response.body) as List<dynamic>;
        _modulesList = responseJsonList
            .map((x) => AppModule.fromJson(x as Map<String, dynamic>))
            .toList();
        _message = "Success";
        _success = true;
      } else {
        if (kDebugMode) {
          print("API FAILED : ${response.body}");
        }
        _message = "Fail";
        _success = false;
      }
    } catch (error) {
      if (kDebugMode) {
        print("GetAllModules API Exception : $error");
      }
      _message = 'Something went wrong!';
      rethrow;
    }
  }
}
