

class DTTCModel {
  bool success;
  List<DTTCList> data;
  String message;

  DTTCModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory DTTCModel.fromJson(Map<String, dynamic> json) => DTTCModel(
    success: json["success"],
    data: List<DTTCList>.from(json["data"].map((x) => DTTCList.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class DTTCList {
  int id;
  String name;
  dynamic description;
  int active;
  dynamic createdAt;
  dynamic updatedAt;
  List<Term> terms;
  bool? isSelected;
  DTTCList({
    required this.id,
    required this.name,
    this.description,
    required this.active,
    this.createdAt,
    this.updatedAt,
    required this.terms,
    this.isSelected,
  });

  factory DTTCList.fromJson(Map<String, dynamic> json) => DTTCList(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    active: json["active"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    terms: List<Term>.from(json["terms"].map((x) => Term.fromJson(x))),
    isSelected : json["id"] == 1 ? true  : false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "active": active,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "terms": List<dynamic>.from(terms.map((x) => x.toJson())),
  };
}

class Term {
  String term;
  dynamic imageUrl;
  dynamic videoUrl;

  Term({
    required this.term,
    this.imageUrl,
    this.videoUrl,
  });

  factory Term.fromJson(Map<String, dynamic> json) => Term(
    term: json["term"],
    imageUrl: json["image_url"],
    videoUrl: json["video_url"],
  );

  Map<String, dynamic> toJson() => {
    "term": term,
    "image_url": imageUrl,
    "video_url": videoUrl,
  };
}
