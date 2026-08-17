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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _message = "Success";
        if (response.body.isNotEmpty) {
          try {
            final decoded = jsonDecode(response.body);
            if (decoded is Map<String, dynamic>) {
              final responseData = AddCreditResponse.fromJson(decoded);
              _makeSongResponse = responseData;
              
              final statusVal = responseData.status;
              if (statusVal == false || statusVal == 0 || statusVal == "false" || statusVal == "error" || statusVal == "fail") {
                _success = false;
                _message = responseData.message ?? "Top-up failed";
              } else {
                _success = true;
                if (responseData.message != null && responseData.message!.isNotEmpty) {
                  _message = responseData.message!;
                }
              }
            } else {
              _success = true;
              _makeSongResponse = AddCreditResponse(
                status: true,
                message: "Success",
                result: Result(credit: decoded.toString()),
              );
            }
          } catch (e) {
            debugPrint("PARSING WARNING: $e");
            _success = true;
            _message = "Success";
          }
        } else {
          _success = true;
        }
      } else {
        debugPrint("ADD CREDITS FAILED [${response.statusCode}]: ${response.body}");
        _message = "Top-up failed (${response.statusCode})";
        _success = false;
      }
    } catch (error, stackTrace) {
      debugPrint("ADD CREDITS EXCEPTION: $error \n$stackTrace");
      _message = error.toString();
      _success = false;
    }
  }
}
