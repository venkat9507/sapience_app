

import 'package:flutter/material.dart';

class DTTCInsideModel {
  bool success;
  List<DTTCInsideModelList> data;
  String message;
  final String? title;

  DTTCInsideModel({
    required this.success,
    required this.data,
    required this.message,
    required this.title,
  });

  factory DTTCInsideModel.fromJson(Map<String, dynamic> json,String title) => DTTCInsideModel(
    success: json["success"],
    data: List<DTTCInsideModelList>.from(json["data"].map((x) => DTTCInsideModelList.fromJson(x))),
    message: json["message"],
    title: title,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class DTTCInsideModelList {
  int id;
  int sectionId;
  String title;
  dynamic description;
  dynamic duration;
  String term;
  String imageUrl;
  String videoUrl;
  DateTime createdAt;
  DateTime updatedAt;
  bool isSelected;
  Color borderColor;

  DTTCInsideModelList({
    required this.id,
    required this.sectionId,
    required this.title,
    this.description,
    this.duration,
    required this.term,
    required this.imageUrl,
    required this.videoUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.isSelected,
    required this.borderColor,
  });

  factory DTTCInsideModelList.fromJson(Map<String, dynamic> json) => DTTCInsideModelList(
    id: json["id"],
    sectionId: json["section_id"],
    title: json["title"],
    description: json["description"],
    duration: json["duration"],
    term: json["term"],
    imageUrl: json["image_url"],
    videoUrl: json["video_url"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
      isSelected: false,
      borderColor: Colors.blue
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "section_id": sectionId,
    "title": title,
    "description": description,
    "duration": duration,
    "term": term,
    "image_url": imageUrl,
    "video_url": videoUrl,
    "created_at": "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
    "updated_at": "${updatedAt.year.toString().padLeft(4, '0')}-${updatedAt.month.toString().padLeft(2, '0')}-${updatedAt.day.toString().padLeft(2, '0')}",
  };
}
