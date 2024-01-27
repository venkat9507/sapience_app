// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../config/color_const.dart';


VideoCategoryModel videoCategoryModelString(String str) => VideoCategoryModel.fromJson(json.decode(str));


class VideoCategoryModel {
  bool success;
  List<VideoCategoriesList> data;
  String message;

  VideoCategoryModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory VideoCategoryModel.fromJson(Map<String, dynamic> json) => VideoCategoryModel(
    success: json["success"],
    data: List<VideoCategoriesList>.from(json["data"].map((x) => VideoCategoriesList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class VideoCategoriesList {
  int? id;
  int? sectionId;
  String? name;
  String? description;
  String? accessibility;
  int? limit;
  int? order;
  int? active;
  String? image;
  DateTime createdAt;
  DateTime updatedAt;
  bool isSelected;
  Color borderColor;
  bool isLkgFoodCategory;

  VideoCategoriesList({
    required this.id,
    required this.sectionId,
    required this.name,
    required this.description,
    required this.accessibility,
    this.limit,
    required this.order,
    required this.active,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.isSelected,
    required this.borderColor,
    required this.isLkgFoodCategory,
  });

  factory VideoCategoriesList.fromJson(Map<String, dynamic> json) {
    debugPrint('id--> ${json["id"]} section_id ${json["section_id"]} name ${json["name"]} description ${json["description"]} accessibility ${json["accessibility"]} limit ${json["limit"]} '
        'order ${json["order"]} active ${json["active"]} image ${json["image"]} created_at ${json["created_at"]} updated_at${json["updated_at"]}');
    return
      VideoCategoriesList(
        id: json["id"],
        sectionId: json["section_id"],
        name: json["name"]??'',
        description: json["description"] ?? '',
        accessibility: json["accessibility"]??'',
        limit: json["limit"],
        order: json["order"],
        active: json["active"],
        image: json["image"]??'',
        createdAt: DateTime.parse(json["created_at"]??DateTime.now().toString()),
        updatedAt: DateTime.parse(json["updated_at"]??DateTime.now().toString()),
        isSelected: false,
        borderColor: primaryBlue,
        isLkgFoodCategory: false,
      );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "section_id": sectionId,
    "name": name,
    "description": description,
    "accessibility": accessibility,
    "limit": limit,
    "order": order,
    "active": active,
    "image": image,
    "created_at": "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
    "updated_at": "${updatedAt.year.toString().padLeft(4, '0')}-${updatedAt.month.toString().padLeft(2, '0')}-${updatedAt.day.toString().padLeft(2, '0')}",
  };
}
