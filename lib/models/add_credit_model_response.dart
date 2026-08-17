class AddCreditResponse {
  final dynamic status;
  final String? message;
  final Result? result;

  AddCreditResponse({
    this.status,
    this.message,
    this.result,
  });

  factory AddCreditResponse.fromJson(Map<String, dynamic> json) {
    Result? res;
    if (json["result"] != null) {
      if (json["result"] is Map<String, dynamic>) {
        res = Result.fromJson(json["result"] as Map<String, dynamic>);
      } else {
        res = Result(credit: json["result"].toString());
      }
    } else if (json["data"] != null) {
      if (json["data"] is Map<String, dynamic>) {
        res = Result.fromJson(json["data"] as Map<String, dynamic>);
      } else {
        res = Result(credit: json["data"].toString());
      }
    } else if (json["credit"] != null) {
      res = Result(credit: json["credit"].toString());
    } else if (json["credits"] != null) {
      res = Result(credit: json["credits"].toString());
    } else if (json["total_credits"] != null) {
      res = Result(credit: json["total_credits"].toString());
    }

    return AddCreditResponse(
      status: json["status"] ?? json["success"],
      message: json["message"]?.toString() ?? json["error"]?.toString() ?? json["msg"]?.toString(),
      result: res,
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

  factory Result.fromJson(Map<String, dynamic> json) {
    dynamic rawCredit = json["credit"] ??
        json["credits"] ??
        json["total_credits"] ??
        json["user_credits"] ??
        json["new_credits"] ??
        json["balance"];

    if (rawCredit == null && json["user"] is Map<String, dynamic>) {
      final userMap = json["user"] as Map<String, dynamic>;
      rawCredit = userMap["credit"] ?? userMap["credits"] ?? userMap["total_credits"];
    }

    return Result(
      credit: rawCredit?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "credit": credit,
  };
}