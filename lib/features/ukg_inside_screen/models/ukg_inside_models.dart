import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nimu_tv/config/color_const.dart';

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



class UkgInsideModel {
  bool success;
  List<UkgInsideModelList> data;
  String message;
  final String? title;
  final int? sectionID;
  final int?  catID;
  final String? videoUrl;

  UkgInsideModel({
    required this.success,
    required this.data,
    required this.message,
    required this.title,
    required this.sectionID,
    required this.catID,
    required this.videoUrl,
  });

  factory UkgInsideModel.fromJson(Map<String, dynamic> json, {String? title,int? sectionID,int? catID,String? videoUrl}) => UkgInsideModel(
    success: json["success"],
    data: List<UkgInsideModelList>.from(json["data"].map((x) => UkgInsideModelList.fromJson(x))),
    message: json["message"],
    title: title,
    sectionID: sectionID,catID: catID,videoUrl: videoUrl
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class UkgInsideModelList {
  int id;
  int sectionId;
  int videoCatId;
  Rx<int>? downloadPercentage;
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
  Rx<bool> isDownloaded;
  Color borderColor;

  UkgInsideModelList({
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
    required this.downloadPercentage,
    required this.isDownloaded,
  });

  factory UkgInsideModelList.fromJson(Map<String, dynamic> json)  {


    return
      UkgInsideModelList(
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
          borderColor: primaryBlue,
          isDownloaded: Rx(false),
          downloadPercentage: null
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
    "created_at": "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
    "updated_at": "${updatedAt.year.toString().padLeft(4, '0')}-${updatedAt.month.toString().padLeft(2, '0')}-${updatedAt.day.toString().padLeft(2, '0')}",
  };
}

Future<bool> checkingTheDownloadFile(String videoUrl) async {
  var isFileExists =  await File('/data/user/0/com.sapience.students/app_flutter/video-url/$videoUrl').exists();

  if(isFileExists) {
    return true;
  }  else
  {
    return false;
  }
  // debugPrint(' checking file exists $videoUrl is file exists $isFileExists');
}
