import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/master_diskon_create_model.dart';

String masterDiskonSaveModelToJson(MasterDiskonSaveModel data) =>
    json.encode(data.toJson());

class MasterDiskonSaveModel {
  MasterDiskonSaveModel({
    required this.deskripsi,
    required this.nilai,
    required this.persen,
  });

  String deskripsi;
  int nilai;
  int persen;

  Map<String, dynamic> toJson() => {
        "deskripsi": deskripsi,
        "nilai": nilai,
        "persen": persen,
      };
}

ResponseMasterDiskonSaveModel responseMasterDiskonSaveModelFromJson(
        dynamic str) =>
    ResponseMasterDiskonSaveModel.fromJson(str);

class ResponseMasterDiskonSaveModel {
  ResponseMasterDiskonSaveModel({
    required this.data,
    required this.message,
  });

  MasterDiskon data;
  String message;

  factory ResponseMasterDiskonSaveModel.fromJson(Map<String, dynamic> json) =>
      ResponseMasterDiskonSaveModel(
        data: MasterDiskon.fromJson(json["data"]),
        message: json["message"],
      );
}
