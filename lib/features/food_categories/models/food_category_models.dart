// To parse this JSON data, do
//
//     final foodCategoryModel = foodCategoryModelFromJson(jsonString);

import 'dart:convert';

FoodCategoryModel foodCategoryModelFromJson(String str) => FoodCategoryModel.fromJson(json.decode(str));

String foodCategoryModelToJson(FoodCategoryModel data) => json.encode(data.toJson());

class FoodCategoryModel {
  bool success;
  List<FoodCategoryList> data;
  String message;

  FoodCategoryModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory FoodCategoryModel.fromJson(Map<String, dynamic> json) => FoodCategoryModel(
    success: json["success"],
    data: List<FoodCategoryList>.from(json["data"].map((x) => FoodCategoryList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class FoodCategoryList {
  int id;
  int sectionId;
  String name;
  dynamic description;
  int active;
  String image;
  DateTime createdAt;
  DateTime updatedAt;

  FoodCategoryList({
    required this.id,
    required this.sectionId,
    required this.name,
    required this.description,
    required this.active,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FoodCategoryList.fromJson(Map<String, dynamic> json) => FoodCategoryList(
    id: json["id"],
    sectionId: json["section_id"],
    name: json["name"],
    description: json["description"],
    active: json["active"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "section_id": sectionId,
    "name": name,
    "description": description,
    "active": active,
    "image": image,
    "created_at": "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
    "updated_at": "${updatedAt.year.toString().padLeft(4, '0')}-${updatedAt.month.toString().padLeft(2, '0')}-${updatedAt.day.toString().padLeft(2, '0')}",
  };
}
