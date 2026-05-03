class CreateStyleTransferResponse {
  final Data? data;
  final String? message;
  final int? status;

  CreateStyleTransferResponse({
    this.data,
    this.message,
    this.status,
  });

  factory CreateStyleTransferResponse.fromJson(Map<String, dynamic> json) => CreateStyleTransferResponse(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "message": message,
    "status": status,
  };
}

class Data {
  final String? userId;
  final String? inputImage;
  final String? outputImage;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  Data({
    this.userId,
    this.inputImage,
    this.outputImage,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    inputImage: json["input_image"],
    outputImage: json["output_image"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "input_image": inputImage,
    "output_image": outputImage,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}