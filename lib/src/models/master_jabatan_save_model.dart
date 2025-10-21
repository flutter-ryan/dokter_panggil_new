import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/master_jabatan_model.dart';

String masterJabatanSaveModelToJson(MasterJabatanSaveModel data) =>
    json.encode(data.toJson());

class MasterJabatanSaveModel {
  MasterJabatanSaveModel({
    required this.jabatan,
    required this.group,
  });

  String jabatan;
  int group;

  Map<String, dynamic> toJson() => {
        "jabatan": jabatan,
        "group": group,
      };
}

ResponseMasterJabatanSaveModel responseMasterJabatanSaveModelFromJson(
        dynamic str) =>
    ResponseMasterJabatanSaveModel.fromJson(str);

class ResponseMasterJabatanSaveModel {
  ResponseMasterJabatanSaveModel({
    this.data,
    this.message,
  });

  Jabatan? data;
  String? message;

  factory ResponseMasterJabatanSaveModel.fromJson(Map<String, dynamic> json) =>
      ResponseMasterJabatanSaveModel(
        data: Jabatan.fromJson(json["data"]),
        message: json["message"],
      );
}
