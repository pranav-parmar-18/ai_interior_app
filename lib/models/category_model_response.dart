// class CategoryModelResponse {
//   final CategoryModelResponseResult? result;
//
//   CategoryModelResponse({
//     this.result,
//   });
//
//   factory CategoryModelResponse.fromJson(Map<String, dynamic> json) => CategoryModelResponse(
//     result: json["result"] == null ? null : CategoryModelResponseResult.fromJson(json["result"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "result": result?.toJson(),
//   };
// }
//
// class CategoryModelResponseResult {
//   final TagSong? tagSong;
//
//   CategoryModelResponseResult({
//     this.tagSong,
//   });
//
//   factory CategoryModelResponseResult.fromJson(Map<String, dynamic> json) => CategoryModelResponseResult(
//     tagSong: json["tag_song"] == null ? null : TagSong.fromJson(json["tag_song"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "tag_song": tagSong?.toJson(),
//   };
// }
//
// class TagSong {
//   final int? totalHits;
//   final List<ResultElement>? result;
//   final int? fromIndex;
//   final int? pageSize;
//
//   TagSong({
//     this.totalHits,
//     this.result,
//     this.fromIndex,
//     this.pageSize,
//   });
//
//   factory TagSong.fromJson(Map<String, dynamic> json) => TagSong(
//     totalHits: json["total_hits"],
//     result: json["result"] == null ? [] : List<ResultElement>.from(json["result"]!.map((x) => ResultElement.fromJson(x))),
//     fromIndex: json["from_index"],
//     pageSize: json["page_size"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "total_hits": totalHits,
//     "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
//     "from_index": fromIndex,
//     "page_size": pageSize,
//   };
// }
//
// class ResultElement {
//   final String? id;
//   final EntityType? entityType;
//   final String? videoUrl;
//   final String? audioUrl;
//   final String? imageUrl;
//   final String? imageLargeUrl;
//   final MajorModelVersion? majorModelVersion;
//   final ModelName? modelName;
//   final Metadata? metadata;
//   final String? caption;
//   final bool? isLiked;
//   final String? userId;
//   final String? displayName;
//   final String? handle;
//   final bool? isHandleUpdated;
//   final String? avatarImageUrl;
//   final bool? isTrashed;
//   final bool? explicit;
//   final int? commentCount;
//   final int? flagCount;
//   final DateTime? createdAt;
//   final Status? status;
//   final String? title;
//   final int? playCount;
//   final int? upvoteCount;
//   final bool? isPublic;
//   final bool? allowComments;
//   final Persona? persona;
//
//   ResultElement({
//     this.id,
//     this.entityType,
//     this.videoUrl,
//     this.audioUrl,
//     this.imageUrl,
//     this.imageLargeUrl,
//     this.majorModelVersion,
//     this.modelName,
//     this.metadata,
//     this.caption,
//     this.isLiked,
//     this.userId,
//     this.displayName,
//     this.handle,
//     this.isHandleUpdated,
//     this.avatarImageUrl,
//     this.isTrashed,
//     this.explicit,
//     this.commentCount,
//     this.flagCount,
//     this.createdAt,
//     this.status,
//     this.title,
//     this.playCount,
//     this.upvoteCount,
//     this.isPublic,
//     this.allowComments,
//     this.persona,
//   });
//
//   factory ResultElement.fromJson(Map<String, dynamic> json) => ResultElement(
//     id: json["id"],
//     entityType: entityTypeValues.map[json["entity_type"]]!,
//     videoUrl: json["video_url"],
//     audioUrl: json["audio_url"],
//     imageUrl: json["image_url"],
//     imageLargeUrl: json["image_large_url"],
//     majorModelVersion: majorModelVersionValues.map[json["major_model_version"]]!,
//     modelName: modelNameValues.map[json["model_name"]]!,
//     metadata: json["metadata"] == null ? null : Metadata.fromJson(json["metadata"]),
//     caption: json["caption"],
//     isLiked: json["is_liked"],
//     userId: json["user_id"],
//     displayName: json["display_name"],
//     handle: json["handle"],
//     isHandleUpdated: json["is_handle_updated"],
//     avatarImageUrl: json["avatar_image_url"],
//     isTrashed: json["is_trashed"],
//     explicit: json["explicit"],
//     commentCount: json["comment_count"],
//     flagCount: json["flag_count"],
//     createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//     status: statusValues.map[json["status"]]!,
//     title: json["title"],
//     playCount: json["play_count"],
//     upvoteCount: json["upvote_count"],
//     isPublic: json["is_public"],
//     allowComments: json["allow_comments"],
//     persona: json["persona"] == null ? null : Persona.fromJson(json["persona"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "entity_type": entityTypeValues.reverse[entityType],
//     "video_url": videoUrl,
//     "audio_url": audioUrl,
//     "image_url": imageUrl,
//     "image_large_url": imageLargeUrl,
//     "major_model_version": majorModelVersionValues.reverse[majorModelVersion],
//     "model_name": modelNameValues.reverse[modelName],
//     "metadata": metadata?.toJson(),
//     "caption": caption,
//     "is_liked": isLiked,
//     "user_id": userId,
//     "display_name": displayName,
//     "handle": handle,
//     "is_handle_updated": isHandleUpdated,
//     "avatar_image_url": avatarImageUrl,
//     "is_trashed": isTrashed,
//     "explicit": explicit,
//     "comment_count": commentCount,
//     "flag_count": flagCount,
//     "created_at": createdAt?.toIso8601String(),
//     "status": statusValues.reverse[status],
//     "title": title,
//     "play_count": playCount,
//     "upvote_count": upvoteCount,
//     "is_public": isPublic,
//     "allow_comments": allowComments,
//     "persona": persona?.toJson(),
//   };
// }
//
// enum EntityType {
//   SONG_SCHEMA
// }
//
// final entityTypeValues = EnumValues({
//   "song_schema": EntityType.SONG_SCHEMA
// });
//
// enum MajorModelVersion {
//   V3_5,
//   V4
// }
//
// final majorModelVersionValues = EnumValues({
//   "v3.5": MajorModelVersion.V3_5,
//   "v4": MajorModelVersion.V4
// });
//
// class Metadata {
//   final String? tags;
//   final String? prompt;
//   final String? gptDescriptionPrompt;
//   final Type? type;
//   final double? duration;
//   final bool? refundCredits;
//   final bool? stream;
//   final bool? canRemix;
//   final int? priority;
//   final List<ConcatHistory>? concatHistory;
//   final String? editedClipId;
//   final String? editSessionId;
//   final bool? hasVocal;
//   final String? freeQuotaCategory;
//   final String? personaId;
//   final String? upsampleClipId;
//   final String? task;
//   final String? coverClipId;
//   final String? negativeTags;
//
//   Metadata({
//     this.tags,
//     this.prompt,
//     this.gptDescriptionPrompt,
//     this.type,
//     this.duration,
//     this.refundCredits,
//     this.stream,
//     this.canRemix,
//     this.priority,
//     this.concatHistory,
//     this.editedClipId,
//     this.editSessionId,
//     this.hasVocal,
//     this.freeQuotaCategory,
//     this.personaId,
//     this.upsampleClipId,
//     this.task,
//     this.coverClipId,
//     this.negativeTags,
//   });
//
//   factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
//     tags: json["tags"],
//     prompt: json["prompt"],
//     gptDescriptionPrompt: json["gpt_description_prompt"],
//     type: typeValues.map[json["type"]]!,
//     duration: json["duration"]?.toDouble(),
//     refundCredits: json["refund_credits"],
//     stream: json["stream"],
//     canRemix: json["can_remix"],
//     priority: json["priority"],
//     concatHistory: json["concat_history"] == null ? [] : List<ConcatHistory>.from(json["concat_history"]!.map((x) => ConcatHistory.fromJson(x))),
//     editedClipId: json["edited_clip_id"],
//     editSessionId: json["edit_session_id"],
//     hasVocal: json["has_vocal"],
//     freeQuotaCategory: json["free_quota_category"],
//     personaId: json["persona_id"],
//     upsampleClipId: json["upsample_clip_id"],
//     task: json["task"],
//     coverClipId: json["cover_clip_id"],
//     negativeTags: json["negative_tags"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "tags": tags,
//     "prompt": prompt,
//     "gpt_description_prompt": gptDescriptionPrompt,
//     "type": typeValues.reverse[type],
//     "duration": duration,
//     "refund_credits": refundCredits,
//     "stream": stream,
//     "can_remix": canRemix,
//     "priority": priority,
//     "concat_history": concatHistory == null ? [] : List<dynamic>.from(concatHistory!.map((x) => x.toJson())),
//     "edited_clip_id": editedClipId,
//     "edit_session_id": editSessionId,
//     "has_vocal": hasVocal,
//     "free_quota_category": freeQuotaCategory,
//     "persona_id": personaId,
//     "upsample_clip_id": upsampleClipId,
//     "task": task,
//     "cover_clip_id": coverClipId,
//     "negative_tags": negativeTags,
//   };
// }
//
// class ConcatHistory {
//   final String? id;
//   final Type? type;
//   final bool? infill;
//   final String? source;
//   final double? continueAt;
//
//   ConcatHistory({
//     this.id,
//     this.type,
//     this.infill,
//     this.source,
//     this.continueAt,
//   });
//
//   factory ConcatHistory.fromJson(Map<String, dynamic> json) => ConcatHistory(
//     id: json["id"],
//     type: typeValues.map[json["type"]]!,
//     infill: json["infill"],
//     source: json["source"],
//     continueAt: json["continue_at"]?.toDouble(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "type": typeValues.reverse[type],
//     "infill": infill,
//     "source": source,
//     "continue_at": continueAt,
//   };
// }
//
// enum Type {
//   CONCAT,
//   EDIT_CROP,
//   EDIT_FADE,
//   GEN,
//   UPSAMPLE
// }
//
// final typeValues = EnumValues({
//   "concat": Type.CONCAT,
//   "edit_crop": Type.EDIT_CROP,
//   "edit_fade": Type.EDIT_FADE,
//   "gen": Type.GEN,
//   "upsample": Type.UPSAMPLE
// });
//
// enum ModelName {
//   CHIRP_V3,
//   CHIRP_V4
// }
//
// final modelNameValues = EnumValues({
//   "chirp-v3": ModelName.CHIRP_V3,
//   "chirp-v4": ModelName.CHIRP_V4
// });
//
// class Persona {
//   final String? id;
//   final String? name;
//   final String? imageS3Id;
//   final String? rootClipId;
//   final String? userHandle;
//   final String? userDisplayName;
//   final String? userImageUrl;
//   final bool? isOwned;
//   final bool? isPublic;
//   final bool? isTrashed;
//
//   Persona({
//     this.id,
//     this.name,
//     this.imageS3Id,
//     this.rootClipId,
//     this.userHandle,
//     this.userDisplayName,
//     this.userImageUrl,
//     this.isOwned,
//     this.isPublic,
//     this.isTrashed,
//   });
//
//   factory Persona.fromJson(Map<String, dynamic> json) => Persona(
//     id: json["id"],
//     name: json["name"],
//     imageS3Id: json["image_s3_id"],
//     rootClipId: json["root_clip_id"],
//     userHandle: json["user_handle"],
//     userDisplayName: json["user_display_name"],
//     userImageUrl: json["user_image_url"],
//     isOwned: json["is_owned"],
//     isPublic: json["is_public"],
//     isTrashed: json["is_trashed"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "image_s3_id": imageS3Id,
//     "root_clip_id": rootClipId,
//     "user_handle": userHandle,
//     "user_display_name": userDisplayName,
//     "user_image_url": userImageUrl,
//     "is_owned": isOwned,
//     "is_public": isPublic,
//     "is_trashed": isTrashed,
//   };
// }
//
// enum Status {
//   COMPLETE
// }
//
// final statusValues = EnumValues({
//   "complete": Status.COMPLETE
// });
//
// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }

import 'explore_model_response.dart';

class CategoryModelResponse {
  final CategoryModelResponseResult? result;

  CategoryModelResponse({this.result});

  factory CategoryModelResponse.fromJson(Map<String, dynamic> json) => CategoryModelResponse(
    result: json["result"] != null ? CategoryModelResponseResult.fromJson(json["result"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "result": result?.toJson(),
  };
}

class CategoryModelResponseResult {
  final TagSong? tagSong;

  CategoryModelResponseResult({this.tagSong});

  factory CategoryModelResponseResult.fromJson(Map<String, dynamic> json) => CategoryModelResponseResult(
    tagSong: json["public_song"] != null ? TagSong.fromJson(json["public_song"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "tag_song": tagSong?.toJson(),
  };
}

class TagSong {
  final int? totalHits;
  final List<ResultElement>? result;
  final int? fromIndex;
  final int? pageSize;

  TagSong({this.totalHits, this.result, this.fromIndex, this.pageSize});

  factory TagSong.fromJson(Map<String, dynamic> json) => TagSong(
    totalHits: json["total_hits"],
    result: json["result"] != null
        ? List<ResultElement>.from(
        json["result"].map((x) => ResultElement.fromJson(x)))
        : [],
    fromIndex: json["from_index"],
    pageSize: json["page_size"],
  );

  Map<String, dynamic> toJson() => {
    "total_hits": totalHits,
    "from_index": fromIndex,
    "page_size": pageSize,
  };
}

class ResultElement {
  final String? id;
  final EntityType? entityType;
  final String? videoUrl;
  final String? audioUrl;
  final String? imageUrl;
  final String? imageLargeUrl;
  final MajorModelVersion? majorModelVersion;
  final ModelName? modelName;
  final String? caption;
  final bool? isLiked;
  final String? userId;
  final String? displayName;
  final String? handle;
  final bool? isHandleUpdated;
  final String? avatarImageUrl;
  final bool? isTrashed;
  final bool? explicit;
  final int? commentCount;
  final int? flagCount;
  final DateTime? createdAt;
  final Status? status;
  final String? title;
  final int? playCount;
  final int? upvoteCount;
  final bool? isPublic;
  final bool? allowComments;

  ResultElement({
    this.id,
    this.entityType,
    this.videoUrl,
    this.audioUrl,
    this.imageUrl,
    this.imageLargeUrl,
    this.majorModelVersion,
    this.modelName,
    this.caption,
    this.isLiked,
    this.userId,
    this.displayName,
    this.handle,
    this.isHandleUpdated,
    this.avatarImageUrl,
    this.isTrashed,
    this.explicit,
    this.commentCount,
    this.flagCount,
    this.createdAt,
    this.status,
    this.title,
    this.playCount,
    this.upvoteCount,
    this.isPublic,
    this.allowComments,
  });

  factory ResultElement.fromJson(Map<String, dynamic> json) => ResultElement(
    id: json["id"],
    entityType: entityTypeValues.map[json["entity_type"]],
    videoUrl: json["video_url"],
    audioUrl: json["audio_url"],
    imageUrl: json["image_url"],
    title: json["title"],
    displayName: json["display_name"],
    imageLargeUrl: json["image_large_url"],
    majorModelVersion: majorModelVersionValues.map[json["major_model_version"]],
    modelName: modelNameValues.map[json["model_name"]],
    createdAt: json["created_at"] != null ? DateTime.tryParse(json["created_at"]) : null,
    status: statusValues.map[json["status"]],
  );

}

// Enums and Utility Classes

enum EntityType { SONG_SCHEMA }
final entityTypeValues = EnumValues({"song_schema": EntityType.SONG_SCHEMA});

enum MajorModelVersion { V3_5, V4 }
final majorModelVersionValues = EnumValues({"v3.5": MajorModelVersion.V3_5, "v4": MajorModelVersion.V4});

enum ModelName { CHIRP_V3, CHIRP_V4 }
final modelNameValues = EnumValues({"chirp-v3": ModelName.CHIRP_V3, "chirp-v4": ModelName.CHIRP_V4});

enum Status { COMPLETE }
final statusValues = EnumValues({"complete": Status.COMPLETE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
