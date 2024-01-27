

class RatingModel {
  bool success;
  RatingData data;
  String message;

  RatingModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
    success: json["success"],
    data: RatingData.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "message": message,
  };
}

class RatingData {
  int videoId;
  int rating;
  int createdBy;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  RatingData({
    required this.videoId,
    required this.rating,
    required this.createdBy,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory RatingData.fromJson(Map<String, dynamic> json) => RatingData(
    videoId: json["video_id"],
    rating: json["rating"],
    createdBy: json["created_by"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "video_id": videoId,
    "rating": rating,
    "created_by": createdBy,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}
