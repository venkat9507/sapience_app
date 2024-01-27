// To parse this JSON data, do
//
//     final qrModel = qrModelFromJson(jsonString);

import 'dart:convert';

QrModel qrModelFromJson(String str) => QrModel.fromJson(json.decode(str));

String qrModelToJson(QrModel data) => json.encode(data.toJson());

class QrModel {
  bool success;
  Data data;
  String message;

  QrModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory QrModel.fromJson(Map<String, dynamic> json) => QrModel(
    success: json["success"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "message": message,
  };
}

class Data {
  int subsId;
  int userId;
  DateTime startDate;
  DateTime endDate;
  String status;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Data({
    required this.subsId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    subsId: json["subs_id"],
    userId: json["user_id"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    status: json["status"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "subs_id": subsId,
    "user_id": userId,
    "start_date": startDate.toIso8601String(),
    "end_date": endDate.toIso8601String(),
    "status": status,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}
