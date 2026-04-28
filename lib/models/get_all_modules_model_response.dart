class GetAllModules {
  final int? id;
  final String? module;
  final String? tableName;
  final String? credit;
  final String? status;
  final String? thumbnail;
  final String? description;
  final dynamic createdAt;
  final DateTime? updatedAt;

  GetAllModules({
    this.id,
    this.module,
    this.tableName,
    this.credit,
    this.status,
    this.thumbnail,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory GetAllModules.fromJson(Map<String, dynamic> json) => GetAllModules(
    id: json["id"],
    module: json["module"],
    tableName: json["table_name"],
    credit: json["credit"],
    status: json["status"],
    thumbnail: json["thumbnail"],
    description: json["description"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "module": module,
    "table_name": tableName,
    "credit": credit,
    "status": status,
    "thumbnail": thumbnail,
    "description": description,
    "created_at": createdAt,
    "updated_at": updatedAt?.toIso8601String(),
  };
}