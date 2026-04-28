class GetGiftListResponse {
  final bool? status;
  final String? message;
  final List<Result>? result;

  GetGiftListResponse({
    this.status,
    this.message,
    this.result,
  });

  factory GetGiftListResponse.fromJson(Map<String, dynamic> json) => GetGiftListResponse(
    status: json["status"],
    message: json["message"],
    result: json["result"] == null ? [] : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class Result {
  final String? name;
  final String? image;
  final int? credit;

  Result({
    this.name,
    this.image,
    this.credit,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    name: json["name"],
    image: json["image"],
    credit: json["credit"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": image,
    "credit": credit,
  };
}