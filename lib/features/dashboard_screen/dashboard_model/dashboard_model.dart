import 'dart:ui';
import 'dart:convert';


// class DashboardModel {
//   String? title;
//   bool? isSelected;
//   int? index;
//   DashboardModel({this.title,this.isSelected,this.index});
// }

// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);


DashboardModel dashboardModelFromJson(String str) => DashboardModel.fromJson(json.decode(str));

class DashboardModel {
  bool success;
  List<DashboardList> data;
  String message;

  DashboardModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    success: json["success"],
    data: List<DashboardList>.from(json["data"].map((x) => DashboardList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class DashboardList {
  int index;
  String name;
  dynamic description;
  int active;
  dynamic createdAt;
  dynamic updatedAt;
  bool? isSelected;
  DashboardList({
    required this.index,
    required this.name,
    this.description,
    required this.active,
    this.createdAt,
    this.updatedAt,
    required this.isSelected,
  });

  factory DashboardList.fromJson(Map<String, dynamic> json) {
    print('checking the json ID ${json['id']}');
    return DashboardList(
      index: json["id"],
      name: json["name"],
      description: json["description"],
      active: json["active"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      isSelected : json["id"] == 1 ? true  : false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": index,
    "name": name,
    "description": description,
    "active": active,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
