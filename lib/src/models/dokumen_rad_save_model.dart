import 'dart:convert';

import 'package:dokter_panggil/src/models/dokumen_rad_model.dart';

DokumenRadSaveModel dokumenRadSaveModelFromJson(dynamic str) =>
    DokumenRadSaveModel.fromJson(str);

class DokumenRadSaveModel {
  DokumenRad? data;
  String? message;

  DokumenRadSaveModel({
    this.data,
    this.message,
  });

  factory DokumenRadSaveModel.fromJson(Map<String, dynamic> json) =>
      DokumenRadSaveModel(
        data: json["data"] == null ? null : DokumenRad.fromJson(json["data"]),
        message: json["message"],
      );
}

String dokumenRadRequestModelToJson(DokumenRadRequestModel data) =>
    json.encode(data.toJson());

class DokumenRadRequestModel {
  String image;
  String ext;

  DokumenRadRequestModel({
    required this.image,
    required this.ext,
  });

  Map<String, dynamic> toJson() => {
        "image": image,
        "ext": ext,
      };
}
