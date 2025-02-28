import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

TagihanTindakanLabSaveModel tagihanTindakanLabSaveModelFromJson(dynamic str) =>
    TagihanTindakanLabSaveModel.fromJson(str);

class TagihanTindakanLabSaveModel {
  DetailKunjungan? data;
  String? message;

  TagihanTindakanLabSaveModel({
    this.data,
    this.message,
  });

  factory TagihanTindakanLabSaveModel.fromJson(Map<String, dynamic> json) =>
      TagihanTindakanLabSaveModel(
        data: json["data"] == null
            ? null
            : DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}

String tagihanTindakanLabRequestModelToJson(
        TagihanTindakanLabRequestModel data) =>
    json.encode(data.toJson());

class TagihanTindakanLabRequestModel {
  List<TindakanLabRequest> tindakanLab;

  TagihanTindakanLabRequestModel({
    required this.tindakanLab,
  });

  Map<String, dynamic> toJson() => {
        "tindakanLab": List<dynamic>.from(tindakanLab.map((x) => x.toJson())),
      };
}

class TindakanLabRequest {
  int id;
  int hargaModal;
  int tarifAplikasi;

  TindakanLabRequest({
    required this.id,
    required this.hargaModal,
    required this.tarifAplikasi,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "hargaModal": hargaModal,
        "tarifAplikasi": tarifAplikasi,
      };
}
