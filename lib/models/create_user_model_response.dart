class CreateUserModelResponse {
  final Data? data;
  final int? credits;
  final int? status;

  CreateUserModelResponse({
    this.data,
    this.credits,
    this.status,
  });

  factory CreateUserModelResponse.fromJson(Map<String, dynamic> json) => CreateUserModelResponse(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    credits: json["credits"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "credits": credits,
    "status": status,
  };
}

class Data {
  final Identifier? identifier;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  Data({
    this.identifier,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    identifier: json["identifier"] == null ? null : Identifier.fromJson(json["identifier"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "identifier": identifier?.toJson(),
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}

class Identifier {
  final String? transactionId;
  final String? uuid;
  final String? socialId;

  Identifier({
    this.transactionId,
    this.uuid,
    this.socialId,
  });

  factory Identifier.fromJson(Map<String, dynamic> json) => Identifier(
    transactionId: json["transaction_id"],
    uuid: json["uuid"],
    socialId: json["social_id"],
  );

  Map<String, dynamic> toJson() => {
    "transaction_id": transactionId,
    "uuid": uuid,
    "social_id": socialId,
  };
}