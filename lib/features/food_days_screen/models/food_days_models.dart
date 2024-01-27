// To parse this JSON data, do
//
//     final foodDaysModel = foodDaysModelFromJson(jsonString);

import 'dart:convert';

FoodDaysModel foodDaysModelFromJson(String str) => FoodDaysModel.fromJson(json.decode(str));

String foodDaysModelToJson(FoodDaysModel data) => json.encode(data.toJson());

class FoodDaysModel {
  bool success;
  List<FoodDaysList> data;
  String message;
  String? title;

  FoodDaysModel({
    required this.success,
    required this.data,
    required this.message,
    this.title
  });

  factory FoodDaysModel.fromJson(Map<String, dynamic> json,{String? title}) => FoodDaysModel(
    success: json["success"],
    data: List<FoodDaysList>.from(json["data"].map((x) => FoodDaysList.fromJson(x))),
    message: json["message"],
    title: title,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class FoodDaysList {
  int id;
  String name;
  dynamic description;
  int active;
  String image;
  DateTime createdAt;
  DateTime updatedAt;

  FoodDaysList({
    required this.id,
    required this.name,
    required this.description,
    required this.active,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FoodDaysList.fromJson(Map<String, dynamic> json) => FoodDaysList(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    active: json["active"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "active": active,
    "image": image,
    "created_at": "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
    "updated_at": "${updatedAt.year.toString().padLeft(4, '0')}-${updatedAt.month.toString().padLeft(2, '0')}-${updatedAt.day.toString().padLeft(2, '0')}",
  };
}
