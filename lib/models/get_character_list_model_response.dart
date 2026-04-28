class GetCharacterListResponse {
  final bool? status;
  final String? message;
  final List<Result>? result;
  final int? lastPage;
  final int? totalRecords;

  GetCharacterListResponse({
    this.status,
    this.message,
    this.result,
    this.lastPage,
    this.totalRecords,
  });

  factory GetCharacterListResponse.fromJson(Map<String, dynamic> json) => GetCharacterListResponse(
    status: json["status"],
    message: json["message"],
    result: json["result"] == null ? [] : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
    lastPage: json["last_page"],
    totalRecords: json["total_records"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "last_page": lastPage,
    "total_records": totalRecords,
  };
}

class Result {
  final int? id;
  final String? name;
  final String? image;

  Result({
    this.id,
    this.name,
    this.image,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
  };
}