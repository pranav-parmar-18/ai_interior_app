class SmartReplaceCreateModelResponse {
  final Data? data;
  final String? message;
  final int? status;

  SmartReplaceCreateModelResponse({
    this.data,
    this.message,
    this.status,
  });

  factory SmartReplaceCreateModelResponse.fromJson(Map<String, dynamic> json) => SmartReplaceCreateModelResponse(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    message: json["message"],
    status: json["status"] is int ? json["status"] : int.tryParse(json["status"]?.toString() ?? ""),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "message": message,
    "status": status,
  };
}

class Data {
  final String? userId;
  final String? prompt;
  final String? inputImage;
  final String? outputImage;
  final int? id;

  Data({
    this.userId,
    this.prompt,
    this.inputImage,
    this.outputImage,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"]?.toString(),
    prompt: json["prompt"]?.toString(),
    inputImage: json["input_image"]?.toString(),
    outputImage: json["output_image"]?.toString(),
    id: json["id"] is int ? json["id"] as int : int.tryParse(json["id"]?.toString() ?? ""),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "prompt": prompt,
    "input_image": inputImage,
    "output_image": outputImage,
    "id": id,
  };
}
