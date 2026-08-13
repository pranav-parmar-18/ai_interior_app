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

  static List<AppModule> get defaultModules => [
        AppModule(
          id: 1,
          module: "Revamp Your Entire",
          description: "Transform your space with a fresh design",
          tableName: "interior_designs",
          thumbnail: "https://instea.org/ai-home/public/thumbnail/interior.png",
        ),
        AppModule(
          id: 2,
          module: "Redesign Your Exterior",
          description: "Transform your outdoor space",
          tableName: "exterior_designs",
          thumbnail: "https://instea.org/ai-home/public/thumbnail/exterior.png",
        ),
        AppModule(
          id: 3,
          module: "Style Transfer",
          description: "Apply a style from any reference image",
          tableName: "style_transfers",
          thumbnail: "https://instea.org/ai-home/public/thumbnail/style-transfer.png",
        ),
        AppModule(
          id: 4,
          module: "Smart Staging",
          description: "Effortlessly furnish and style your room",
          tableName: "smart_stagings",
          thumbnail: "https://instea.org/ai-home/public/thumbnail/smart-staging.png",
        ),
        AppModule(
          id: 5,
          module: "Replace",
          description: "Replace any part of your space with ease",
          tableName: "smart_replaces",
          thumbnail: "https://instea.org/ai-home/public/thumbnail/replace.png",
        ),
        AppModule(
          id: 6,
          module: "Design Your Dream Space",
          description: "Build your ideal space from scratch",
          tableName: "dream_spaces",
          thumbnail: "https://instea.org/ai-home/public/thumbnail/dream-space.png",
        ),
        AppModule(
          id: 7,
          module: "Enhance Your Existing Space",
          description: "Improve your existing space with ease",
          tableName: "enhanced_spaces",
          thumbnail: "https://instea.org/ai-home/public/thumbnail/",
        ),
      ];
}
