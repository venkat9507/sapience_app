import 'dart:ui';

import 'package:flutter/material.dart';

// class LkgInsideModel {
//   String? thumbNail;
//   String? title;
//   String? subTitle;
//   String? id;
//   String? borderColor;
//   String? watchHistory;
//   double? rating;
//   bool? isSelected;
//   LkgInsideModel({this.watchHistory,this.rating,this.thumbNail,this.borderColor,this.title,this.id,this.isSelected,this.subTitle});
// }

// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);



class KFVInsideModel {
  bool success;
  List<KFVInsideModelList> data;
  String message = 'checking the message';
  final String? title;

  KFVInsideModel({
    required this.success,
    required this.data,
    required this.message,
    required this.title,
  });

  factory KFVInsideModel.fromJson(Map<String, dynamic> json,String title) => KFVInsideModel(
    success: json["success"],
    data: List<KFVInsideModelList>.from(json["data"].map((x) => KFVInsideModelList.fromJson(x))),
    message: json["message"],
    title: title,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class KFVInsideModelList {
  int id;
  int sectionId;
  int videoCatId;
  String title;
  dynamic description;
  dynamic duration;
  dynamic term;
  dynamic ddtc;
  String imageUrl;
  String videoUrl;
  int views;
  double rating;
  DateTime createdAt;
  DateTime updatedAt;
  bool isSelected;
  Color borderColor;

  KFVInsideModelList({
    required this.id,
    required this.sectionId,
    required this.videoCatId,
    required this.title,
    this.description,
    this.duration,
    this.term,
    this.ddtc,
    required this.imageUrl,
    required this.videoUrl,
    required this.views,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
    required this.isSelected,
    required this.borderColor,
  });

  factory KFVInsideModelList.fromJson(Map<String, dynamic> json) => KFVInsideModelList(
      id: json["id"],
      sectionId: json["section_id"],
      videoCatId: json["video_cat_id"],
      title: json["title"],
      description: json["description"],
      duration: json["duration"],
      term: json["term"],
      ddtc: json["ddtc"],
      imageUrl: json["image_url"],
      videoUrl: json["video_url"],
      views: json["views"],
      // rating: 1,
      rating: double.parse(json["rating"].toString()),
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      isSelected: false,
      borderColor: Colors.blue
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "section_id": sectionId,
    "video_cat_id": videoCatId,
    "title": title,
    "description": description,
    "duration": duration,
    "term": term,
    "ddtc": ddtc,
    "image_url": imageUrl,
    "video_url": videoUrl,
    "views": views,
    "rating": rating,
    "created_at": "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
    "updated_at": "${updatedAt.year.toString().padLeft(4, '0')}-${updatedAt.month.toString().padLeft(2, '0')}-${updatedAt.day.toString().padLeft(2, '0')}",
  };
}
