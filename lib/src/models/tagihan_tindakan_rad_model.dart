import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String tagihanTindakanRadModelToJson(TagihanTindakanRadModel data) =>
    json.encode(data.toJson());

class TagihanTindakanRadModel {
  int idKunjungan;
  String norm;
  List<int> idTindakan;
  List<int> hargaModal;
  List<int> tarifAplikasi;

  TagihanTindakanRadModel({
    required this.idKunjungan,
    required this.norm,
    required this.idTindakan,
    required this.hargaModal,
    required this.tarifAplikasi,
  });

  Map<String, dynamic> toJson() => {
        "idKunjungan": idKunjungan,
        "norm": norm,
        "idTindakan": List<dynamic>.from(idTindakan.map((x) => x)),
        "hargaModal": List<dynamic>.from(hargaModal.map((x) => x)),
        "tarifAplikasi": List<dynamic>.from(tarifAplikasi.map((x) => x)),
      };
}

ResponseTagihanTindakanRadModel responseTagihanTindakanRadModelFromJson(
        dynamic str) =>
    ResponseTagihanTindakanRadModel.fromJson(str);

class ResponseTagihanTindakanRadModel {
  DetailKunjungan? data;
  String? message;

  ResponseTagihanTindakanRadModel({
    this.data,
    this.message,
  });

  factory ResponseTagihanTindakanRadModel.fromJson(Map<String, dynamic> json) =>
      ResponseTagihanTindakanRadModel(
        data: DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
