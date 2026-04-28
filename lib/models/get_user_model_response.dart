class UserModelResponse {
  final bool? status;
  final String? message;
  final Result? result;

  UserModelResponse({
    this.status,
    this.message,
    this.result,
  });

  factory UserModelResponse.fromJson(Map<String, dynamic> json) => UserModelResponse(
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
  final dynamic otId;
  final dynamic fcmToken;
  final String? ip;
  final bool? isInapp;
  final int? credits;
  final dynamic lastDailyCreditAt;
  final String? currentAppVersion;
  final String? language;
  final bool? appleSignin;
  final dynamic email;
  final dynamic name;
  final dynamic gender;
  final dynamic age;
  final dynamic bio;
  final String? profilePic;
  final bool? isNotiEnable;
  final int? status;
  final dynamic onboardingDetails;
  final String? shareProfileLink;

  Result({
    this.id,
    this.udId,
    this.otId,
    this.fcmToken,
    this.ip,
    this.isInapp,
    this.credits,
    this.lastDailyCreditAt,
    this.currentAppVersion,
    this.language,
    this.appleSignin,
    this.email,
    this.name,
    this.gender,
    this.age,
    this.bio,
    this.profilePic,
    this.isNotiEnable,
    this.status,
    this.onboardingDetails,
    this.shareProfileLink,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    udId: json["ud_id"],
    otId: json["ot_id"],
    fcmToken: json["fcm_token"],
    ip: json["ip"],
    isInapp: json["is_inapp"],
    credits: json["credits"],
    lastDailyCreditAt: json["last_daily_credit_at"],
    currentAppVersion: json["current_app_version"],
    language: json["language"],
    appleSignin: json["apple_signin"],
    email: json["email"],
    name: json["name"],
    gender: json["gender"],
    age: json["age"],
    bio: json["bio"],
    profilePic: json["profile_pic"],
    isNotiEnable: json["is_noti_enable"],
    status: json["status"],
    onboardingDetails: json["onboarding_details"],
    shareProfileLink: json["shareProfileLink"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ud_id": udId,
    "ot_id": otId,
    "fcm_token": fcmToken,
    "ip": ip,
    "is_inapp": isInapp,
    "credits": credits,
    "last_daily_credit_at": lastDailyCreditAt,
    "current_app_version": currentAppVersion,
    "language": language,
    "apple_signin": appleSignin,
    "email": email,
    "name": name,
    "gender": gender,
    "age": age,
    "bio": bio,
    "profile_pic": profilePic,
    "is_noti_enable": isNotiEnable,
    "status": status,
    "onboarding_details": onboardingDetails,
    "shareProfileLink": shareProfileLink,
  };
}
