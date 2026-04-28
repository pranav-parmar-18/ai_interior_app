class GetAiMessageDetailsResponse {
  final bool? status;
  final String? message;
  final List<Result>? result;
  final String? image;

  GetAiMessageDetailsResponse({
    this.status,
    this.message,
    this.result,
    this.image,
  });

  factory GetAiMessageDetailsResponse.fromJson(Map<String, dynamic> json) => GetAiMessageDetailsResponse(
    status: json["status"],
    message: json["message"],
    result: json["result"] == null ? [] : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "image": image,
  };
}

class Result {
  final String? role;
  final List<Content>? content;

  Result({
    this.role,
    this.content,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    role: json["role"],
    content: json["content"] == null ? [] : List<Content>.from(json["content"]!.map((x) => Content.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "role": role,
    "content": content == null ? [] : List<dynamic>.from(content!.map((x) => x.toJson())),
  };
}

class Content {
  final String? type;
  final String? text;
  final int? messageType;
  final String? uuid;
  final int? isViewed;

  Content({
    this.type,
    this.text,
    this.messageType,
    this.uuid,
    this.isViewed,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    type: json["type"],
    text: json["text"],
    messageType: json["message_type"],
    uuid: json["uuid"],
    isViewed: json["is_viewed"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "text": text,
    "message_type": messageType,
    "uuid": uuid,
    "is_viewed": isViewed,
  };
}