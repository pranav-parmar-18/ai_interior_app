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

      const String url = '${ProjectConstant.baseUrl}user/top-up/v2';
      
      String uuid = await DeviceIdManager.getDeviceId();
      String productId = data['product_id'] ?? "";
      String rawTxnId = (data['transactionId'] ?? data['transaction_id'] ?? "").toString();
      String transactionId = (rawTxnId.isEmpty || rawTxnId == "null")
          ? "txn_${DateTime.now().millisecondsSinceEpoch}"
          : rawTxnId;

      Map<String, dynamic> payload = {
        "uuid": uuid,
        "product_id": productId,
        "transaction_id": transactionId,
      };

      String jsonPayload = jsonEncode(payload);

      debugPrint("ADD CREDITS URL: $url");
      debugPrint("ADD CREDITS PAYLOAD: $jsonPayload");
      debugPrint("ADD CREDITS TOKEN: $accessToken");

      final response = await http.post(
        Uri.parse(url),
        body: jsonPayload,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (accessToken.isNotEmpty) 'Authorization': 'Bearer $accessToken',
        },
      );

      debugPrint("ADD CREDITS RESPONSE [${response.statusCode}]: ${response.body}");

      if (response.statusCode == 200) {
        final responseJsonMap =
            jsonDecode(response.body) as Map<String, dynamic>;
        final responseData = AddCreditResponse.fromJson(responseJsonMap);
        _makeSongResponse = responseData;
        if (_makeSongResponse!.status == true) {
          debugPrint("STATUS SUCCESS: ${_makeSongResponse!.status}");
          _message = "Success";
          _success = true;
        } else {
          debugPrint("STATUS FAIL: ${_makeSongResponse!.status}");
          _message = responseData.message ?? "Top-up failed";
          _success = false;
        }
      } else {
        if (kDebugMode) {
          debugPrint("API FAILED : ${response.body}");
        }
        try {
          final responseJsonMap =
              jsonDecode(response.body) as Map<String, dynamic>;
          final responseData = AddCreditResponse.fromJson(responseJsonMap);
          _makeSongResponse = responseData;
          _message = responseData.message ?? "Fail";
        } catch (_) {
          _message = "Server error (${response.statusCode})";
        }
        _success = false;
      }
    } catch (error) {
      debugPrint("ADD CREDITS EXCEPTION: $error");
      _message = 'Something went wrong!';
      _success = false;
      rethrow;
    }
  }
}
