class SendAIMessageModelResponse {
  final bool? status;
  final String? message;
  final Result? result;

  SendAIMessageModelResponse({
    this.status,
    this.message,
    this.result,
  });

  factory SendAIMessageModelResponse.fromJson(Map<String, dynamic> json) => SendAIMessageModelResponse(
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

  Content({
    this.type,
    this.text,
    this.messageType,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    type: json["type"],
    text: json["text"],
    messageType: json["message_type"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "text": text,
    "message_type": messageType,
  };
}