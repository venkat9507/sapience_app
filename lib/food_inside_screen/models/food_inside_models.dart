// To parse this JSON data, do
//
//     final foodInsideModel = foodInsideModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

FoodInsideModel foodInsideModelFromJson(String str) => FoodInsideModel.fromJson(json.decode(str));

String foodInsideModelToJson(FoodInsideModel data) => json.encode(data.toJson());

class FoodInsideModel {
  bool success;
  List<FoodInsideModelList> data;
  String message;
  String? title;
  int? sectionID;
  int? foodDayID;
  int? foodCatID;
  int? foodTypeID;
  FoodInsideModel({
    required this.success,
    required this.data,
    required this.message,
    this.foodDayID,this.sectionID,this.foodTypeID,this.foodCatID,this.title
  });

  factory FoodInsideModel.fromJson(Map<String, dynamic> json,{
    int? sectionID,
    int? foodDayID,
    int? foodCatID ,
    int? foodTypeID ,
    String? title,
}) => FoodInsideModel(
    success: json["success"],
    data: List<FoodInsideModelList>.from(json["data"].map((x) => FoodInsideModelList.fromJson(x))),
    message: json["message"],
    title: title,sectionID: sectionID,foodCatID: foodCatID,foodDayID: foodDayID,foodTypeID: foodTypeID,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class FoodInsideModelList {
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
  Rx<bool> isDownloaded;

  FoodInsideModelList({
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
    required this.isDownloaded,
  });

  factory FoodInsideModelList.fromJson(Map<String, dynamic> json) => FoodInsideModelList(
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
    isDownloaded: Rx(false),
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

Future<bool> checkingTheFoodDownloadFile(String videoUrl) async {
  var isFileExists =  await File('/data/user/0/com.example.nimu_tv/app_flutter/video-url/$videoUrl').exists();

  if(isFileExists) {
    return true;
  }  else
  {
    return false;
  }
  // debugPrint(' checking file exists $videoUrl is file exists $isFileExists');
}