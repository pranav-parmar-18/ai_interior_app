class ProfileMatchResponse {
  final bool? status;
  final String? message;
  final List<dynamic>? result;

  ProfileMatchResponse({
    this.status,
    this.message,
    this.result,
  });

  factory ProfileMatchResponse.fromJson(Map<String, dynamic> json) => ProfileMatchResponse(
    status: json["status"],
    message: json["message"],
    result: json["result"] == null ? [] : List<dynamic>.from(json["result"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x)),
  };
}