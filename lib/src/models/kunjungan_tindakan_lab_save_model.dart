import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String kunjunganTindakanbLabSaveModelToJson(
        KunjunganTindakanbLabSaveModel data) =>
    json.encode(data.toJson());

class KunjunganTindakanbLabSaveModel {
  KunjunganTindakanbLabSaveModel({
    required this.tindakanLab,
    required this.hargaModal,
    required this.tarifAplikasi,
  });

  int tindakanLab;
  int hargaModal;
  int tarifAplikasi;

  Map<String, dynamic> toJson() => {
        "tindakanLab": tindakanLab,
        "hargaModal": hargaModal,
        "tarifAplikasi": tarifAplikasi,
      };
}

ResponseKunjunganTindakanbLabSaveModel
    responseKunjunganTindakanbLabSaveModelFromJson(dynamic str) =>
        ResponseKunjunganTindakanbLabSaveModel.fromJson(str);

class ResponseKunjunganTindakanbLabSaveModel {
  ResponseKunjunganTindakanbLabSaveModel({
    this.data,
    this.message,
  });

  DetailKunjungan? data;
  String? message;

  factory ResponseKunjunganTindakanbLabSaveModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseKunjunganTindakanbLabSaveModel(
        data: DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
