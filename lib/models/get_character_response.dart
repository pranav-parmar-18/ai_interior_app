class CharacterResponse {
  final bool? status;
  final String? message;
  final Result? result;

  CharacterResponse({
    this.status,
    this.message,
    this.result,
  });

  factory CharacterResponse.fromJson(Map<String, dynamic> json) => CharacterResponse(
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
  final dynamic appUserId;
  final int? seed;
  final int? type;
  final int? characterType;
  final int? gender;
  final String? name;
  final String? image;
  final int? chats;
  final bool? isPrivate;
  final OtherData? otherData;

  Result({
    this.id,
    this.appUserId,
    this.seed,
    this.type,
    this.characterType,
    this.gender,
    this.name,
    this.image,
    this.chats,
    this.isPrivate,
    this.otherData,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    appUserId: json["app_user_id"],
    seed: json["seed"],
    type: json["type"],
    characterType: json["character_type"],
    gender: json["gender"],
    name: json["name"],
    image: json["image"],
    chats: json["chats"],
    isPrivate: json["is_private"],
    otherData: json["other_data"] == null ? null : OtherData.fromJson(json["other_data"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "app_user_id": appUserId,
    "seed": seed,
    "type": type,
    "character_type": characterType,
    "gender": gender,
    "name": name,
    "image": image,
    "chats": chats,
    "is_private": isPrivate,
    "other_data": otherData?.toJson(),
  };
}

class OtherData {
  final String? voice;
  final String? behaviour;
  final String? persona;
  final String? firstMessage;

  OtherData({
    this.voice,
    this.behaviour,
    this.persona,
    this.firstMessage,
  });

  factory OtherData.fromJson(Map<String, dynamic> json) => OtherData(
    voice: json["voice"],
    behaviour: json["behaviour"],
    persona: json["persona"],
    firstMessage: json["first_message"],
  );

  Map<String, dynamic> toJson() => {
    "voice": voice,
    "behaviour": behaviour,
    "persona": persona,
    "first_message": firstMessage,
  };
}
