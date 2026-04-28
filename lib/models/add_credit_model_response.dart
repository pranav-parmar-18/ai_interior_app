class AddCreditResponse {
  final bool? status;
  final String? message;
  final Result? result;

  AddCreditResponse({
    this.status,
    this.message,
    this.result,
  });

  factory AddCreditResponse.fromJson(Map<String, dynamic> json) => AddCreditResponse(
    status: json["status"],
    message: json["message"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
  );

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
    credit: json["credit"],
  );

  Map<String, dynamic> toJson() => {
    "credit": credit,
  };
}