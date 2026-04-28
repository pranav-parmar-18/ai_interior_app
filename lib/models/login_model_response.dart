class LoginModelResponse {
  final bool? status;
  final String? message;
  final Result? result;

  LoginModelResponse({
    this.status,
    this.message,
    this.result,
  });

  factory LoginModelResponse.fromJson(Map<String, dynamic> json) => LoginModelResponse(
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
  final int? id;
  final String? udId;
  final String? otId;
  final String? currentAppVersion;
  final String? fcmToken;
  final int? credits;
  final String? accessToken;

  Result({
    this.id,
    this.udId,
    this.otId,
    this.currentAppVersion,
    this.fcmToken,
    this.credits,
    this.accessToken,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    udId: json["ud_id"],
    otId: json["ot_id"],
    currentAppVersion: json["current_app_version"],
    fcmToken: json["fcm_token"],
    credits: json["credits"],
    accessToken: json["access_token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ud_id": udId,
    "ot_id": otId,
    "current_app_version": currentAppVersion,
    "fcm_token": fcmToken,
    "credits": credits,
    "access_token": accessToken,
  };
}