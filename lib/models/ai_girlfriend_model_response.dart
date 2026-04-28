class AIGirlfriendCreateModelResponse {
  final bool? status;
  final String? message;
  final Result? result;

  AIGirlfriendCreateModelResponse({
    this.status,
    this.message,
    this.result,
  });

  factory AIGirlfriendCreateModelResponse.fromJson(Map<String, dynamic> json) => AIGirlfriendCreateModelResponse(
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
  final int? type;
  final int? characterType;
  final int? gender;
  final String? name;
  final String? image;
  final bool? isPrivate;
  final OtherData? otherData;
  final int? appUserId;
  final int? seed;
  final int? chats;
  final int? id;

  Result({
    this.type,
    this.characterType,
    this.gender,
    this.name,
    this.image,
    this.isPrivate,
    this.otherData,
    this.appUserId,
    this.seed,
    this.chats,
    this.id,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    type: json["type"],
    characterType: json["character_type"],
    gender: json["gender"],
    name: json["name"],
    image: json["image"],
    isPrivate: json["is_private"],
    otherData: json["other_data"] == null ? null : OtherData.fromJson(json["other_data"]),
    appUserId: json["app_user_id"],
    seed: json["seed"],
    chats: json["chats"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "character_type": characterType,
    "gender": gender,
    "name": name,
    "image": image,
    "is_private": isPrivate,
    "other_data": otherData?.toJson(),
    "app_user_id": appUserId,
    "seed": seed,
    "chats": chats,
    "id": id,
  };
}

class OtherData {
  final String? identity;
  final String? age;
  final String? hairColor;
  final String? hairStyle;
  final String? bodyType;
  final String? breastSize;
  final String? buttSize;
  final String? personality;
  final String? voice;
  final String? occupation;
  final String? clothing;
  final String? hobbies;
  final String? relationship;
  final String? firstMessage;

  OtherData({
    this.identity,
    this.age,
    this.hairColor,
    this.hairStyle,
    this.bodyType,
    this.breastSize,
    this.buttSize,
    this.personality,
    this.voice,
    this.occupation,
    this.clothing,
    this.hobbies,
    this.relationship,
    this.firstMessage,
  });

  factory OtherData.fromJson(Map<String, dynamic> json) => OtherData(
    identity: json["identity"],
    age: json["age"],
    hairColor: json["hair_color"],
    hairStyle: json["hair_style"],
    bodyType: json["body_type"],
    breastSize: json["breast_size"],
    buttSize: json["butt_size"],
    personality: json["personality"],
    voice: json["voice"],
    occupation: json["occupation"],
    clothing: json["clothing"],
    hobbies: json["hobbies"],
    relationship: json["relationship"],
    firstMessage: json["first_message"],
  );

  Map<String, dynamic> toJson() => {
    "identity": identity,
    "age": age,
    "hair_color": hairColor,
    "hair_style": hairStyle,
    "body_type": bodyType,
    "breast_size": breastSize,
    "butt_size": buttSize,
    "personality": personality,
    "voice": voice,
    "occupation": occupation,
    "clothing": clothing,
    "hobbies": hobbies,
    "relationship": relationship,
    "first_message": firstMessage,
  };
}