// To parse this JSON data, do
//
//     final foodVideoModel = foodVideoModelFromJson(jsonString);

import 'dart:convert';

FoodVideoModel foodVideoModelFromJson(String str) => FoodVideoModel.fromJson(json.decode(str));

String foodVideoModelToJson(FoodVideoModel data) => json.encode(data.toJson());

class FoodVideoModel {
  bool success;
  FoodVideoData data;
  String message;

  FoodVideoModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory FoodVideoModel.fromJson(Map<String, dynamic> json) => FoodVideoModel(
    success: json["success"],
    data: FoodVideoData.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "message": message,
  };
}

class FoodVideoData {
  int id;
  int sectionId;
  int foodCategoryId;
  int foodTypeId;
  int foodDayId;
  String title;
  String description;
  dynamic duration;
  String imageUrl;
  String videoUrl;
  int views;
  int rating;
  DateTime createdAt;
  DateTime updatedAt;

  FoodVideoData({
    required this.id,
    required this.sectionId,
    required this.foodCategoryId,
    required this.foodTypeId,
    required this.foodDayId,
    required this.title,
    required this.description,
    required this.duration,
    required this.imageUrl,
    required this.videoUrl,
    required this.views,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FoodVideoData.fromJson(Map<String, dynamic> json) => FoodVideoData(
    id: json["id"],
    sectionId: json["section_id"],
    foodCategoryId: json["food_category_id"],
    foodTypeId: json["food_type_id"],
    foodDayId: json["food_day_id"],
    title: json["title"],
    description: json["description"],
    duration: json["duration"],
    imageUrl: json["image_url"],
    videoUrl: json["video_url"],
    views: json["views"],
    rating: json["rating"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "section_id": sectionId,
    "food_category_id": foodCategoryId,
    "food_type_id": foodTypeId,
    "food_day_id": foodDayId,
    "title": title,
    "description": description,
    "duration": duration,
    "image_url": imageUrl,
    "video_url": videoUrl,
    "views": views,
    "rating": rating,
    "created_at": "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
    "updated_at": "${updatedAt.year.toString().padLeft(4, '0')}-${updatedAt.month.toString().padLeft(2, '0')}-${updatedAt.day.toString().padLeft(2, '0')}",
  };
}
