class PhotosModelResponse {
  final bool? status;
  final String? message;
  final List<String>? result;

  PhotosModelResponse({
    this.status,
    this.message,
    this.result,
  });

  factory PhotosModelResponse.fromJson(Map<String, dynamic> json) => PhotosModelResponse(
    status: json["status"],
    message: json["message"],
    result: json["result"] == null ? [] : List<String>.from(json["result"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x)),
  };
}
