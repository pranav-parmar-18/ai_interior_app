class RecentSingleModelResponse {
  final int? status;
  final String? message;
  final Data? data;

  RecentSingleModelResponse({
    this.status,
    this.message,
    this.data,
  });

  factory RecentSingleModelResponse.fromJson(Map<String, dynamic> json) => RecentSingleModelResponse(
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
  final int? id;
  final int? userId;
  final String? designAsthetic;
  final String? spaceCategory;
  final String? spaceType;
  final String? colors;
  final String? prompt;
  final String? jobId;
  final String? outputImage;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Data({
    this.id,
    this.userId,
    this.designAsthetic,
    this.spaceCategory,
    this.spaceType,
    this.colors,
    this.prompt,
    this.jobId,
    this.outputImage,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: json["user_id"],
    designAsthetic: json["design_asthetic"],
    spaceCategory: json["space_category"],
    spaceType: json["space_type"],
    colors: json["colors"],
    prompt: json["prompt"],
    jobId: json["job_id"],
    outputImage: json["output_image"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "design_asthetic": designAsthetic,
    "space_category": spaceCategory,
    "space_type": spaceType,
    "colors": colors,
    "prompt": prompt,
    "job_id": jobId,
    "output_image": outputImage,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}