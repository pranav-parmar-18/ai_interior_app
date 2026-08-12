class AppModule {
  final int? id;
  final String? module;
  final String? description;
  final String? tableName;
  final String? thumbnail;
  final String? createdAt;
  final String? updatedAt;

  AppModule({
    this.id,
    this.module,
    this.description,
    this.tableName,
    this.thumbnail,
    this.createdAt,
    this.updatedAt,
  });

  factory AppModule.fromJson(Map<String, dynamic> json) => AppModule(
        id: json["id"] is int ? json["id"] : int.tryParse(json["id"]?.toString() ?? ""),
        module: json["module"],
        description: json["description"],
        tableName: json["tableName"] ?? json["table_name"],
        thumbnail: json["thumbnail"],
        createdAt: json["createdAt"] ?? json["created_at"],
        updatedAt: json["updatedAt"] ?? json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "module": module,
        "description": description,
        "tableName": tableName,
        "thumbnail": thumbnail,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
