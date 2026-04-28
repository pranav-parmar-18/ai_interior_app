class ImageGeneratorModelResponse {
  final bool? status;
  final String? message;
  final Result? result;

  ImageGeneratorModelResponse({
    this.status,
    this.message,
    this.result,
  });

  factory ImageGeneratorModelResponse.fromJson(Map<String, dynamic> json) => ImageGeneratorModelResponse(
    status: json["status"],
    message: json["message"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result?.toJson(),
  };
}

class Result {
  final String? image;

  Result({
    this.image,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
  };
}