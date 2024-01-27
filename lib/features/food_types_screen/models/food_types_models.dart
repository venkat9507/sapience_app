// To parse this JSON data, do
//
//     final foodTypesModel = foodTypesModelFromJson(jsonString);

import 'dart:convert';

FoodTypesModel foodTypesModelFromJson(String str) => FoodTypesModel.fromJson(json.decode(str));

String foodTypesModelToJson(FoodTypesModel data) => json.encode(data.toJson());

class FoodTypesModel {
  bool success;
  List<FoodTypesList> data;
  String message;
  String? title;

  FoodTypesModel({
    required this.success,
    required this.data,
    required this.message,
    this.title
  });

  factory FoodTypesModel.fromJson(Map<String, dynamic> json,{String? title}) => FoodTypesModel(
    success: json["success"],
    data: List<FoodTypesList>.from(json["data"].map((x) => FoodTypesList.fromJson(x))),
    message: json["message"], title: title
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class FoodTypesList {
  int id;
  String name;
  dynamic description;
  int active;
  String image;
  DateTime createdAt;
  DateTime updatedAt;

  FoodTypesList({
    required this.id,
    required this.name,
    required this.description,
    required this.active,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FoodTypesList.fromJson(Map<String, dynamic> json) => FoodTypesList(
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
