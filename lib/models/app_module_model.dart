class AppModule {
  final int? id;
  final String? module;
  final String? tableName;
  final String? credit;
  final String? status;
  final String? thumbnail;
  final String? description;

  AppModule({
    this.id,
    this.module,
    this.tableName,
    this.credit,
    this.status,
    this.thumbnail,
    this.description,
  });

  factory AppModule.fromJson(Map<String, dynamic> json) => AppModule(
    id: json["id"],
    module: json["module"],
    tableName: json["table_name"],
    credit: json["credit"]?.toString(),
    status: json["status"],
    thumbnail: json["thumbnail"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "module": module,
    "table_name": tableName,
    "credit": credit,
    "status": status,
    "thumbnail": thumbnail,
    "description": description,
  };
}
