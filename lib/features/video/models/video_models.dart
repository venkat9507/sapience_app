// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);



import 'package:flutter/material.dart';

class VideoModel {
  bool success;
  VideoData data;
  String message;


  VideoModel({
    required this.success,
    required this.data,
    required this.message,

  });

  factory VideoModel.fromJson(Map<String, dynamic> json,) => VideoModel(
    success: json["success"],
    data: VideoData.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "message": message,
  };
}

class VideoData {
  int? id;
  int? sectionId;
  int? videoCatId;
  String? title;
  dynamic description;
  dynamic duration;
  dynamic term;
  dynamic ddtc;
  String? imageUrl;
  String? videoUrl;
  int? views;
  double? rating;
  DateTime? createdAt;
  DateTime? updatedAt;

  VideoData({
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
  });

  factory VideoData.fromJson(Map<String, dynamic> json) {

    // debugPrint('id ${json["id"]}');
    // debugPrint('section id ${json["section_id"]}');
    // debugPrint('views  ${json["views"]}');
    return
      VideoData(
        id: json["id"] ?? 0,
        sectionId: json["section_id"]?? 0,
        videoCatId: json["video_cat_id"]??0,
        title: json["title"]?? '',
        description: json["description"],
        duration: json["duration"],
        term: json["term"],
        ddtc: json["ddtc"],
        imageUrl: json["image_url"]??'',
        videoUrl: json["video_url"]??'',
        views: json["views"]?? 0,
        rating:json["rating"] == null? double.parse('0.0'): double.parse(json["rating"].toString()),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );
  }

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
    "created_at": "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
    "updated_at": "${updatedAt!.year.toString().padLeft(4, '0')}-${updatedAt!.month.toString().padLeft(2, '0')}-${updatedAt!.day.toString().padLeft(2, '0')}",
  };
}
