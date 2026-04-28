class SendPeopleMessageModelResponse {
  final bool? status;
  final String? message;
  final List<dynamic>? result;

  SendPeopleMessageModelResponse({
    this.status,
    this.message,
    this.result,
  });

  factory SendPeopleMessageModelResponse.fromJson(Map<String, dynamic> json) => SendPeopleMessageModelResponse(
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