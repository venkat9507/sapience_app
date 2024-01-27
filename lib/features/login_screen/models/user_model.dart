// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
//
// String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  bool success;
  Data data;
  String message;

  UserModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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
  int id;
  dynamic name;
  dynamic email;
  dynamic emailVerifiedAt;
  String phone;
  dynamic presentAddress;
  dynamic permanentAddress;
  String role;
  DateTime createdAt;
  DateTime updatedAt;
  String token;
  bool userSubscription;
  List<SubscriptionList> subscriptionList;

  Data({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.phone,
    required this.presentAddress,
    required this.permanentAddress,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.token,
    required this.userSubscription,
    required this.subscriptionList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    phone: json["phone"],
    presentAddress: json["present_address"],
    permanentAddress: json["permanent_address"],
    role: json["role"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    token: json['token']?? '',
    userSubscription: json["user_subscription"],
    subscriptionList: List<SubscriptionList>.from(json["subscription_list"].map((x) => SubscriptionList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "phone": phone,
    "present_address": presentAddress,
    "permanent_address": permanentAddress,
    "role": role,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "token": token,
    "user_subscription": userSubscription,
    "subscription_list": List<dynamic>.from(subscriptionList.map((x) => x.toJson())),
  };
}

class SubscriptionList {
  int id;
  int subsId;
  int userId;
  DateTime startDate;
  DateTime endDate;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  Subs subs;

  SubscriptionList({
    required this.id,
    required this.subsId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.subs,
  });

  factory SubscriptionList.fromJson(Map<String, dynamic> json) => SubscriptionList(
    id: json["id"],
    subsId: json["subs_id"],
    userId: json["user_id"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    name: json["name"],
    subs: Subs.fromJson(json["subs"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subs_id": subsId,
    "user_id": userId,
    "start_date": startDate.toIso8601String(),
    "end_date": endDate.toIso8601String(),
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "name": name,
    "subs": subs.toJson(),
  };
}

class Subs {
  int id;
  int sectionId;
  String name;
  dynamic description;
  int days;
  int amount;
  int active;
  dynamic createdAt;
  dynamic updatedAt;
  String sectionName;
  Section section;

  Subs({
    required this.id,
    required this.sectionId,
    required this.name,
    required this.description,
    required this.days,
    required this.amount,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.sectionName,
    required this.section,
  });

  factory Subs.fromJson(Map<String, dynamic> json) => Subs(
    id: json["id"],
    sectionId: json["section_id"],
    name: json["name"],
    description: json["description"],
    days: json["days"],
    amount: json["amount"],
    active: json["active"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    sectionName: json["sectionName"],
    section: Section.fromJson(json["section"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "section_id": sectionId,
    "name": name,
    "description": description,
    "days": days,
    "amount": amount,
    "active": active,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "sectionName": sectionName,
    "section": section.toJson(),
  };
}

class Section {
  int id;
  String name;
  dynamic description;
  int active;
  dynamic createdAt;
  dynamic updatedAt;

  Section({
    required this.id,
    required this.name,
    required this.description,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    active: json["active"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "active": active,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
