import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String tagihanTindakanLabModelToJson(TagihanTindakanLabModel data) =>
    json.encode(data.toJson());

class TagihanTindakanLabModel {
  int idKunjungan;
  String norm;
  List<int> idTindakan;
  List<int> hargaModal;
  List<int> tarifAplikasi;
  bool isPaket;

  TagihanTindakanLabModel({
    required this.idKunjungan,
    required this.norm,
    required this.idTindakan,
    required this.hargaModal,
    required this.tarifAplikasi,
    required this.isPaket,
  });

  Map<String, dynamic> toJson() => {
        "idKunjungan": idKunjungan,
        "norm": norm,
        "idTindakan": List<dynamic>.from(idTindakan.map((x) => x)),
        "hargaModal": List<dynamic>.from(hargaModal.map((x) => x)),
        "tarifAplikasi": List<dynamic>.from(tarifAplikasi.map((x) => x)),
        "isPaket": isPaket,
      };
}

ResponseTagihanTindakanLabModel responseTagihanTindakanLabModelFromJson(
        dynamic str) =>
    ResponseTagihanTindakanLabModel.fromJson(str);

class ResponseTagihanTindakanLabModel {
  DetailKunjungan? data;
  String? message;

  ResponseTagihanTindakanLabModel({
    this.data,
    this.message,
  });

  factory ResponseTagihanTindakanLabModel.fromJson(Map<String, dynamic> json) =>
      ResponseTagihanTindakanLabModel(
        data: DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
