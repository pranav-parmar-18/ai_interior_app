class CharacterPhotosResponse {
  final bool? status;
  final String? message;
  final List<Result>? result;

  CharacterPhotosResponse({
    this.status,
    this.message,
    this.result,
  });

  factory CharacterPhotosResponse.fromJson(Map<String, dynamic> json) => CharacterPhotosResponse(
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
  final int? id;
  final String? image;
  final int? credit;
  final int? isUnlocked;

  Result({
    this.id,
    this.image,
    this.credit,
    this.isUnlocked,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    image: json["image"],
    credit: json["credit"],
    isUnlocked: json["is_unlocked"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "credit": credit,
    "is_unlocked": isUnlocked,
  };
}