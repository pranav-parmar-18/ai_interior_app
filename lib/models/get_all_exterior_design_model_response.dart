class GetAllExteriorDesignModelResponse {
  final String? message;
  final List<Datum>? data;
  final int? status;

  GetAllExteriorDesignModelResponse({
    this.message,
    this.data,
    this.status,
  });

  factory GetAllExteriorDesignModelResponse.fromJson(Map<String, dynamic> json) => GetAllExteriorDesignModelResponse(
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "status": status,
  };
}

class Datum {
  final int? id;
  final int? userId;
  final String? inputImage;
  final String? designAsthetic;
  final String? spaceType;
  final String? colors;
  final String? prompt;
  final dynamic jobId;
  final String? outputImage;
  final String? status;
  final dynamic createdAt;
  final dynamic updatedAt;

  Datum({
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
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
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}