class RecentListModelResponse {
  final int? status;
  final String? message;
  final Data? data;

  RecentListModelResponse({
    this.status,
    this.message,
    this.data,
  });

  factory RecentListModelResponse.fromJson(Map<String, dynamic> json) => RecentListModelResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final int? currentPage;
  final List<Datum>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link>? links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  Data({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: json["data"] == null || json["data"] is! List
        ? []
        : (json["data"] as List).map((x) => Datum.fromJson(x)).toList(),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: json["links"] == null || json["links"] is! List
        ? []
        : (json["links"] as List).map((x) => Link.fromJson(x)).toList(),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": links == null ? [] : List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class Datum {
  final int? id;
  final int? userId;
  final String? inputImage;
  final String? designAsthetic;
  final String? spaceType;
  final String? colors;
  final String? prompt;
  final String? jobId;
  final String? outputImage;
  final Status? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Type? type;

  Datum({
    this.id,
    this.userId,
    this.inputImage,
    this.designAsthetic,
    this.spaceType,
    this.colors,
    this.prompt,
    this.jobId,
    this.outputImage,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.type,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    inputImage: json["input_image"],
    designAsthetic: json["design_asthetic"],
    spaceType: json["space_type"],
    colors: json["colors"],
    prompt: json["prompt"],
    jobId: json["job_id"],
    outputImage: json["output_image"],
    status: statusValues.map[json["status"]],
    createdAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"].toString()),
    updatedAt: json["updated_at"] == null ? null : DateTime.tryParse(json["updated_at"].toString()),
    type: typeValues.map[json["type"]],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "input_image": inputImage,
    "design_asthetic": designAsthetic,
    "space_type": spaceType,
    "colors": colors,
    "prompt": prompt,
    "job_id": jobId,
    "output_image": outputImage,
    "status": statusValues.reverse[status],
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "type": typeValues.reverse[type],
  };
}

enum Status {
  PRIVATE,
  PUBLIC,
}

final statusValues = EnumValues({
  "private": Status.PRIVATE,
  "public": Status.PUBLIC,
});

enum Type {
  INTERIOR_DESIGNS,
  SMART_REPLACES,
  STYLE_TRANSFERS
}

final typeValues = EnumValues({
  "interior_designs": Type.INTERIOR_DESIGNS,
  "smart_replaces": Type.SMART_REPLACES,
  "style_transfers": Type.STYLE_TRANSFERS
});

class Link {
  final String? url;
  final String? label;
  final bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}