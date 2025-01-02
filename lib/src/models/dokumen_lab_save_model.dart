import 'dart:convert';

DokumenLabSaveModel dokumenLabSaveModelFromJson(dynamic str) =>
    DokumenLabSaveModel.fromJson(str);

class DokumenLabSaveModel {
  DokumenLab? data;
  String? message;

  DokumenLabSaveModel({
    this.data,
    this.message,
  });

  factory DokumenLabSaveModel.fromJson(Map<String, dynamic> json) =>
      DokumenLabSaveModel(
        data: json["data"] == null ? null : DokumenLab.fromJson(json["data"]),
        message: json["message"],
      );
}

class DokumenLab {
  int? id;
  String? url;
  String? extension;
  String? confirmedBy;
  String? confirmedAt;
  String? createdAt;

  DokumenLab({
    this.id,
    this.url,
    this.extension,
    this.createdAt,
    this.confirmedAt,
    this.confirmedBy,
  });

  factory DokumenLab.fromJson(Map<String, dynamic> json) => DokumenLab(
        id: json["id"],
        url: json["url"],
        extension: json["extension"],
        createdAt: json["created_at"],
        confirmedAt: json["confirmed_at"],
        confirmedBy: json["confirmed_by"],
      );
}

String dokumenLabRequestModelToJson(DokumenLabRequestModel data) =>
    json.encode(data.toJson());

class DokumenLabRequestModel {
  String image;
  String ext;

  DokumenLabRequestModel({
    required this.image,
    required this.ext,
  });

  Map<String, dynamic> toJson() => {
        "image": image,
        "ext": ext,
      };
}
