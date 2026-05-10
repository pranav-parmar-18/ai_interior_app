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

  Data({
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}