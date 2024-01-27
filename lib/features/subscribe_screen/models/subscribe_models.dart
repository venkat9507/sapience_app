import 'dart:ui';
import 'dart:convert';

import 'package:nimu_tv/config/color_const.dart';

class SubscribeModel {
  String? title;
  double? price;
  String? id;
  String? borderColor;
  bool? isSelected;
  // bool? isSubscribe;
  SubscribeModel({
    this.price,this.borderColor,
    this.title,this.isSelected,
    this.id,
    // this.isSubscribe
  });
}

// To parse this JSON data, do
//
//     final subscriptionPlanModel = subscriptionPlanModelFromJson(jsonString);




class SubscriptionPlanModel {
  bool success;
  List<SubscribeDatum> data;
  String message;

  SubscriptionPlanModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) => SubscriptionPlanModel(
    success: json["success"],
    data: List<SubscribeDatum>.from(json["data"].map((x) => SubscribeDatum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class SubscribeDatum {
  int id;
  int sectionId;
  String title;
  dynamic description;
  int days;
  int price;
  int active;
  dynamic createdAt;
  dynamic updatedAt;
  String? borderColor;
  bool? isSelected;
  bool? isSubscribe;

  SubscribeDatum({
    required this.id,
    required this.sectionId,
    required this.title,
    this.description,
    required this.days,
    required this.price,
    required this.active,
    this.createdAt,
    this.updatedAt,
    this.isSelected,
    this.borderColor,
    this.isSubscribe
  });

  factory SubscribeDatum.fromJson(Map<String, dynamic> json) => SubscribeDatum(
    id: json["id"],
    sectionId: json["section_id"],
    title: json["name"],
    description: json["description"],
    days: json["days"],
    price: json["amount"],
    active: json["active"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    isSelected:  false,
    borderColor: '$primaryBlue'
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "section_id": sectionId,
    "name": title,
    "description": description,
    "days": days,
    "amount": price,
    "active": active,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
