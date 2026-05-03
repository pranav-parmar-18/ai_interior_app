class SmartStagingCreateModelResponse {
  final Data? data;
  final String? message;
  final int? status;

  SmartStagingCreateModelResponse({
    this.data,
    this.message,
    this.status,
  });

  factory SmartStagingCreateModelResponse.fromJson(Map<String, dynamic> json) => SmartStagingCreateModelResponse(
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
  final String? designAsthetic;
  final String? prompt;
  final String? spaceType;
  final String? colors;
  final String? inputImage;
  final String? outputImage;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  Data({
    this.userId,
    this.designAsthetic,
    this.prompt,
    this.spaceType,
    this.colors,
    this.inputImage,
    this.outputImage,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    designAsthetic: json["design_asthetic"],
    prompt: json["prompt"],
    spaceType: json["space_type"],
    colors: json["colors"],
    inputImage: json["input_image"],
    outputImage: json["output_image"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "design_asthetic": designAsthetic,
    "prompt": prompt,
    "space_type": spaceType,
    "colors": colors,
    "input_image": inputImage,
    "output_image": outputImage,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}