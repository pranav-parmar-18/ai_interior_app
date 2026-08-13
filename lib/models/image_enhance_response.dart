class ImageEnhanceResponse {
  final bool? status;
  final String? message;
  final Data? data;

  ImageEnhanceResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ImageEnhanceResponse.fromJson(Map<String, dynamic> json) => ImageEnhanceResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final String? id;
  final List<String>? errors;
  final String? name;

  Data({
    this.id,
    this.errors,
    this.name,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    errors: json["errors"] == null
        ? null
        : List<String>.from(json["errors"].map((x) => x.toString())),
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "errors": errors,
    "name": name,
  };
}