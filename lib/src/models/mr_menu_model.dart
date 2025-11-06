MrMenuModel mrMenuModelFromJson(dynamic str) => MrMenuModel.fromJson(str);

class MrMenuModel {
  String? message;
  List<MrMenu>? data;

  MrMenuModel({
    this.message,
    this.data,
  });

  factory MrMenuModel.fromJson(Map<String, dynamic> json) => MrMenuModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<MrMenu>.from(json["data"].map((x) => MrMenu.fromJson(x))),
      );
}

class MrMenu {
  int? id;
  String? title;
  String? subtitle;
  bool visible;

  MrMenu({
    this.id,
    this.title,
    this.subtitle,
    this.visible = true,
  });

  MrMenu copyWith({bool? visible}) {
    return MrMenu(
      id: id,
      title: title,
      subtitle: subtitle,
      visible: visible ?? this.visible,
    );
  }

  factory MrMenu.fromJson(Map<String, dynamic> json) => MrMenu(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
      );
}
