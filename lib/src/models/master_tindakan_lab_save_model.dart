import 'dart:convert';
import 'package:admin_dokter_panggil/src/models/master_tindakan_lab_all_model.dart';

String masterTindakanLabSaveModelToJson(MasterTindakanLabSaveModel data) =>
    json.encode(data.toJson());

class MasterTindakanLabSaveModel {
  MasterTindakanLabSaveModel({
    required this.kode,
    required this.namaTindakanLab,
    required this.hargaModal,
    required this.persen,
    required this.mitra,
    required this.jenis,
  });

  String kode;
  String namaTindakanLab;
  int hargaModal;
  String persen;
  String mitra;
  String jenis;

  Map<String, dynamic> toJson() => {
        "kode": kode,
        "namaTindakanLab": namaTindakanLab,
        "hargaModal": hargaModal,
        "persen": persen,
        "mitra": mitra,
        "jenis": jenis,
      };
}

ResponseMasterTindakanLabSaveModel responseMasterTindakanLabSaveModelFromJson(
        dynamic str) =>
    ResponseMasterTindakanLabSaveModel.fromJson(str);

class ResponseMasterTindakanLabSaveModel {
  ResponseMasterTindakanLabSaveModel({
    this.data,
    this.message,
  });

  MasterTindakanLabAll? data;
  String? message;

  factory ResponseMasterTindakanLabSaveModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseMasterTindakanLabSaveModel(
        data: MasterTindakanLabAll.fromJson(json["data"]),
        message: json["message"],
      );
}
