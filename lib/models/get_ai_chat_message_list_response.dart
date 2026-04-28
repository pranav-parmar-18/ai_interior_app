class GetAIMessageListResponse {
  final bool? status;
  final String? message;
  final List<AIMSGResult>? result;
  final bool? hasMorePages;
  final String? nextPage;

  GetAIMessageListResponse({
    this.status,
    this.message,
    this.result,
    this.hasMorePages,
    this.nextPage,
  });

  factory GetAIMessageListResponse.fromJson(Map<String, dynamic> json) => GetAIMessageListResponse(
    status: json["status"],
    message: json["message"],
    result: json["result"] == null ? [] : List<AIMSGResult>.from(json["result"]!.map((x) => AIMSGResult.fromJson(x))),
    hasMorePages: json["has_more_pages"],
    nextPage: json["next_page"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "has_more_pages": hasMorePages,
    "next_page": nextPage,
  };
}

class AIMSGResult {
  final int? userId;
  final int? otherUserId;
  final int? fromUserId;
  final String? fromUserName;
  final int? isRead;
  final String? lastMessage;
  final String? lastMessageId;
  final DateTime? lastMessageTime;
  final int? messageType;
  final int? toUserId;
  final String? toUserName;
  final int? lastMessageTimestamp;
  final String? image;

  AIMSGResult({
    this.userId,
    this.otherUserId,
    this.fromUserId,
    this.fromUserName,
    this.isRead,
    this.lastMessage,
    this.lastMessageId,
    this.lastMessageTime,
    this.messageType,
    this.toUserId,
    this.toUserName,
    this.lastMessageTimestamp,
    this.image,
  });

  factory AIMSGResult.fromJson(Map<String, dynamic> json) => AIMSGResult(
    userId: json["user_id"],
    otherUserId: json["other_user_id"],
    fromUserId: json["from_user_id"],
    fromUserName: json["from_user_name"],
    isRead: json["is_read"],
    lastMessage: json["last_message"],
    lastMessageId: json["last_message_id"],
    lastMessageTime: json["last_message_time"] == null ? null : DateTime.parse(json["last_message_time"]),
    messageType: json["message_type"],
    toUserId: json["to_user_id"],
    toUserName: json["to_user_name"],
    lastMessageTimestamp: json["last_message_timestamp"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "other_user_id": otherUserId,
    "from_user_id": fromUserId,
    "from_user_name": fromUserName,
    "is_read": isRead,
    "last_message": lastMessage,
    "last_message_id": lastMessageId,
    "last_message_time": lastMessageTime?.toIso8601String(),
    "message_type": messageType,
    "to_user_id": toUserId,
    "to_user_name": toUserName,
    "last_message_timestamp": lastMessageTimestamp,
    "image": image,
  };
}