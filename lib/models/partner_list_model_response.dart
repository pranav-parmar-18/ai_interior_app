class PartnerListResponse {
  final bool? status;
  final String? message;
  final List<Result>? result;

  PartnerListResponse({
    this.status,
    this.message,
    this.result,
  });

  factory PartnerListResponse.fromJson(Map<String, dynamic> json) => PartnerListResponse(
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
  final String? name;
  final String? image;
  final String? bio;

  Result({
    this.id,
    this.name,
    this.image,
    this.bio,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    bio: json["bio"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "bio": bio,
  };
}