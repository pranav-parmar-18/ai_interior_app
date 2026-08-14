class AddCreditResponse {
  final bool? status;
  final String? message;
  final Result? result;

  AddCreditResponse({
    this.status,
    this.message,
    this.result,
  });

  factory AddCreditResponse.fromJson(Map<String, dynamic> json) {
    bool isSuccess = false;
    if (json["status"] is bool) {
      isSuccess = json["status"] as bool;
    } else if (json["status"] is int) {
      isSuccess = (json["status"] as int) == 200 || (json["status"] as int) == 1;
    } else if (json["status"] is String) {
      final s = (json["status"] as String).toLowerCase();
      isSuccess = s == 'true' || s == '200' || s == '1' || s == 'success';
    }

    String? msg = json["message"]?.toString() ?? json["error"]?.toString();

    return AddCreditResponse(
      status: isSuccess,
      message: msg,
      result: json["result"] == null ? null : Result.fromJson(json["result"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result?.toJson(),
  };
}

class Result {
  final String? credit;

  Result({
    this.credit,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    credit: json["credit"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "credit": credit,
  };
}