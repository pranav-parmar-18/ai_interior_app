class CustomModeResponse {
  final String? message;
  final Data? data;
  final dynamic accountId;

  CustomModeResponse({
    this.message,
    this.data,
    this.accountId,
  });

  factory CustomModeResponse.fromJson(Map<String, dynamic> json) => CustomModeResponse(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    accountId: json["account_id"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "account_id": accountId,
  };
}

class Data {
  final String? id;

  Data({
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}
