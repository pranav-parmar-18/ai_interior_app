part of 'delete_record_bloc.dart';

class DeleteRecordRepository {
  CommonModelResponse? _makeSongResponse;

  CommonModelResponse? get makeSongResponse => _makeSongResponse;

  String _message = '';

  String get message => _message;
  bool? _success;

  bool? get success => _success;

  Future<void> login(Map<String, dynamic> data) async {
    try {
      const String url = '${ProjectConstant.baseUrl}delete';
      String jsonPayload = jsonEncode(data);

      final response = await http.post(
        Uri.parse(url),
        body: jsonPayload,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = CommonModelResponse.fromJson(responseJsonMap);
        print("DELETE Success: ${response.body}");
        _makeSongResponse = responseData;
        _message = responseJsonMap["message"]?.toString() ?? "Success";
        _success = responseJsonMap["error"] == null;
      } else {
        if (kDebugMode) {
          print("DELETE API FAILED : ${response.body}");
        }
        try {
          final responseJsonMap =
              jsonDecode(response.body) as Map<String, dynamic>;
          final responseData = CommonModelResponse.fromJson(responseJsonMap);
          _makeSongResponse = responseData;
          _message = responseJsonMap["error"]?.toString() ?? responseJsonMap["message"]?.toString() ?? "Fail";
        } catch (_) {
          _message = "Fail";
        }
        _success = false;
      }
    } catch (error) {
      _message = 'Something went wrong!';
      _success = false;
      rethrow;
    }
  }
}
