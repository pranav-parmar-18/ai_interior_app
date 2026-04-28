class MakeSongResponse {
  final String? message;
  final int? songId;
  final int? accountId;
  final Data? data;

  MakeSongResponse({
    this.message,
    this.songId,
    this.accountId,
    this.data,
  });

  factory MakeSongResponse.fromJson(Map<String, dynamic> json) => MakeSongResponse(
    message: json["message"],
    songId: json["song_id"],
    accountId: json["account_id"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "song_id": songId,
    "account_id": accountId,
    "data": data?.toJson(),
  };
}

class Data {
  final String? id;
  final String? entityType;
  final String? videoUrl;
  final String? audioUrl;
  final String? imageUrl;
  final String? imageLargeUrl;
  final String? majorModelVersion;
  final String? modelName;
  final Metadata? metadata;
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
  final String? status;
  final String? title;
  final int? playCount;
  final int? upvoteCount;
  final bool? isPublic;
  final bool? allowComments;

  Data({
    this.id,
    this.entityType,
    this.videoUrl,
    this.audioUrl,
    this.imageUrl,
    this.imageLargeUrl,
    this.majorModelVersion,
    this.modelName,
    this.metadata,
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    entityType: json["entity_type"],
    videoUrl: json["video_url"],
    audioUrl: json["audio_url"],
    imageUrl: json["image_url"],
    imageLargeUrl: json["image_large_url"],
    majorModelVersion: json["major_model_version"],
    modelName: json["model_name"],
    metadata: json["metadata"] == null ? null : Metadata.fromJson(json["metadata"]),
    isLiked: json["is_liked"],
    userId: json["user_id"],
    displayName: json["display_name"],
    handle: json["handle"],
    isHandleUpdated: json["is_handle_updated"],
    avatarImageUrl: json["avatar_image_url"],
    isTrashed: json["is_trashed"],
    explicit: json["explicit"],
    commentCount: json["comment_count"],
    flagCount: json["flag_count"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    status: json["status"],
    title: json["title"],
    playCount: json["play_count"],
    upvoteCount: json["upvote_count"],
    isPublic: json["is_public"],
    allowComments: json["allow_comments"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "entity_type": entityType,
    "video_url": videoUrl,
    "audio_url": audioUrl,
    "image_url": imageUrl,
    "image_large_url": imageLargeUrl,
    "major_model_version": majorModelVersion,
    "model_name": modelName,
    "metadata": metadata?.toJson(),
    "is_liked": isLiked,
    "user_id": userId,
    "display_name": displayName,
    "handle": handle,
    "is_handle_updated": isHandleUpdated,
    "avatar_image_url": avatarImageUrl,
    "is_trashed": isTrashed,
    "explicit": explicit,
    "comment_count": commentCount,
    "flag_count": flagCount,
    "created_at": createdAt?.toIso8601String(),
    "status": status,
    "title": title,
    "play_count": playCount,
    "upvote_count": upvoteCount,
    "is_public": isPublic,
    "allow_comments": allowComments,
  };
}

class Metadata {
  final String? tags;
  final String? prompt;
  final String? editedClipId;
  final String? type;
  final double? duration;
  final String? editSessionId;
  final bool? canRemix;

  Metadata({
    this.tags,
    this.prompt,
    this.editedClipId,
    this.type,
    this.duration,
    this.editSessionId,
    this.canRemix,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    tags: json["tags"],
    prompt: json["prompt"],
    editedClipId: json["edited_clip_id"],
    type: json["type"],
    duration: json["duration"]?.toDouble(),
    editSessionId: json["edit_session_id"],
    canRemix: json["can_remix"],
  );

  Map<String, dynamic> toJson() => {
    "tags": tags,
    "prompt": prompt,
    "edited_clip_id": editedClipId,
    "type": type,
    "duration": duration,
    "edit_session_id": editSessionId,
    "can_remix": canRemix,
  };
}
