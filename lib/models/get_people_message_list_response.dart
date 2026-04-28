class GetPeopleRequestMessageListResponse {
  final bool? status;
  final String? message;
  final List<PeopleMSGResult>? result;
  final bool? hasMorePages;
  final String? nextPage;

  GetPeopleRequestMessageListResponse({
    this.status,
    this.message,
    this.result,
    this.hasMorePages,
    this.nextPage,
  });

  factory GetPeopleRequestMessageListResponse.fromJson(Map<String, dynamic> json) => GetPeopleRequestMessageListResponse(
    status: json["status"],
    message: json["message"],
    result: json["result"] == null ? [] : List<PeopleMSGResult>.from(json["result"]!.map((x) => PeopleMSGResult.fromJson(x))),
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

class PeopleMSGResult {
  final int? userId;
  final int? otherUserId;
  final int? fromUserId;
  final String? fromUserName;
  final int? isRead;
  final int? isRequest;
  final String? lastMessage;
  final String? lastMessageId;
  final DateTime? lastMessageTime;
  final int? toUserId;
  final String? toUserName;
  final int? lastMessageTimestamp;
  final dynamic image;

  PeopleMSGResult({
    this.userId,
    this.otherUserId,
    this.fromUserId,
    this.fromUserName,
    this.isRead,
    this.isRequest,
    this.lastMessage,
    this.lastMessageId,
    this.lastMessageTime,
    this.toUserId,
    this.toUserName,
    this.lastMessageTimestamp,
    this.image,
  });

  factory PeopleMSGResult.fromJson(Map<String, dynamic> json) => PeopleMSGResult(
    userId: json["user_id"],
    otherUserId: json["other_user_id"],
    fromUserId: json["from_user_id"],
    fromUserName: json["from_user_name"],
    isRead: json["is_read"],
    isRequest: json["is_request"],
    lastMessage: json["last_message"],
    lastMessageId: json["last_message_id"],
    lastMessageTime: json["last_message_time"] == null ? null : DateTime.parse(json["last_message_time"]),
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
    "is_request": isRequest,
    "last_message": lastMessage,
    "last_message_id": lastMessageId,
    "last_message_time": lastMessageTime?.toIso8601String(),
    "to_user_id": toUserId,
    "to_user_name": toUserName,
    "last_message_timestamp": lastMessageTimestamp,
    "image": image,
  };
}