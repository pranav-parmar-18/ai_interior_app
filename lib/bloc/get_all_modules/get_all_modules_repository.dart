part of 'get_all_modules_bloc.dart';

class GetAllModulesRepository {
  List<AppModule>? _modulesList = AppModule.defaultModules;

  List<AppModule>? get modulesList => _modulesList ?? AppModule.defaultModules;

  String _message = 'Success';

  String get message => _message;
  bool? _success = true;

  bool? get success => _success;

  Future<void> GetAllModules() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String accessToken = preferences.getString('access_token') ?? "";
      const String url = '${ProjectConstant.baseUrl}get-app-modules';

      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $accessToken',
      }).timeout(const Duration(seconds: 5));

      if (kDebugMode) {
        print("STATUS: ${response.statusCode}");
        print("BODY: ${response.body}");
      }
      if (response.statusCode == 200) {
        final List<dynamic> responseJsonList =
            jsonDecode(response.body) as List<dynamic>;
        final fetched = responseJsonList
            .map((x) => AppModule.fromJson(x as Map<String, dynamic>))
            .toList();
        if (fetched.isNotEmpty) {
          _modulesList = fetched;
        }
        _message = "Success";
        _success = true;
      } else {
        _modulesList ??= AppModule.defaultModules;
        _message = "Success";
        _success = true;
      }
    } catch (error) {
      if (kDebugMode) {
        print("GetAllModules API Exception : $error");
      }
      _modulesList ??= AppModule.defaultModules;
      _message = "Success";
      _success = true;
    }
  }
}
