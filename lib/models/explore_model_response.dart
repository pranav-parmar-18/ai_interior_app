class ExploreModelResponse {
  final bool? status;
  final String? message;
  final List<Result>? result;
  final int? lastPage;
  final int? totalRecords;

  ExploreModelResponse({
    this.status,
    this.message,
    this.result,
    this.lastPage,
    this.totalRecords,
  });

  factory ExploreModelResponse.fromJson(Map<String, dynamic> json) => ExploreModelResponse(
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
  final String? chats;
  final String? firstMessage;
  final String? age;
  final int? characterType;
  final String? tags;

  Result({
    this.id,
    this.name,
    this.image,
    this.chats,
    this.firstMessage,
    this.age,
    this.characterType,
    this.tags,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    chats: json["chats"],
    firstMessage: json["first_message"],
    age: json["age"],
    characterType: json["character_type"],
    tags: json["tags"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "chats": chats,
    "first_message": firstMessage,
    "age": age,
    "character_type": characterType,
    "tags": tags,
  };
}