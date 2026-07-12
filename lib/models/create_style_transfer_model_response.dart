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
    userId: json["user_id"]?.toString(),
    inputImage: json["input_image"]?.toString(),
    outputImage: json["output_image"]?.toString(),
    updatedAt: json["updated_at"] == null ? null : DateTime.tryParse(json["updated_at"].toString()),
    createdAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"].toString()),
    id: json["id"] is int ? json["id"] as int : int.tryParse(json["id"]?.toString() ?? ""),
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