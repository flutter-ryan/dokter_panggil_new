import 'dart:convert';

import 'package:dokter_panggil/src/models/master_tindakan_rad_create_mode.dart';

String masterTindakanRadSaveModelToJson(MasterTindakanRadSaveModel data) =>
    json.encode(data.toJson());

class MasterTindakanRadSaveModel {
  String namaTindakan;
  int hargaModal;
  double persen;

  MasterTindakanRadSaveModel({
    required this.namaTindakan,
    required this.hargaModal,
    required this.persen,
  });

  Map<String, dynamic> toJson() => {
        "namaTindakan": namaTindakan,
        "hargaModal": hargaModal,
        "persen": persen,
      };
}

ResponseMasterTindakanRadSaveModel responseMasterTindakanRadSaveModelFromJson(
        dynamic str) =>
    ResponseMasterTindakanRadSaveModel.fromJson(str);

class ResponseMasterTindakanRadSaveModel {
  MasterTindakanRad? data;
  String? message;

  ResponseMasterTindakanRadSaveModel({
    this.data,
    this.message,
  });

  factory ResponseMasterTindakanRadSaveModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseMasterTindakanRadSaveModel(
        data: MasterTindakanRad.fromJson(json["data"]),
        message: json["message"],
      );
}
