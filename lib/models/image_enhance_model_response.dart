class ImageEnhanceModelResponse {
  final bool? success;
  final ImageUrl? imageUrl;

  ImageEnhanceModelResponse({
    this.success,
    this.imageUrl,
  });

  factory ImageEnhanceModelResponse.fromJson(Map<String, dynamic> json) => ImageEnhanceModelResponse(
    success: json["success"],
    imageUrl: json["image_url"] == null ? null : ImageUrl.fromJson(json["image_url"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "image_url": imageUrl?.toJson(),
  };
}

class ImageUrl {
  final int? id;
  final int? userId;
  final String? inputImage;
  final String? designAsthetic;
  final String? spaceType;
  final String? colors;
  final String? prompt;
  final String? jobId;
  final String? outputImage;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ImageUrl({
    this.id,
    this.userId,
    this.inputImage,
    this.designAsthetic,
    this.spaceType,
    this.colors,
    this.prompt,
    this.jobId,
    this.outputImage,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ImageUrl.fromJson(Map<String, dynamic> json) => ImageUrl(
    id: json["id"],
    userId: json["user_id"],
    inputImage: json["input_image"],
    designAsthetic: json["design_asthetic"],
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
    "input_image": inputImage,
    "design_asthetic": designAsthetic,
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