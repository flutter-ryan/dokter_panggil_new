import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String kunjunganResepModelToJson(KunjunganResepModel data) =>
    json.encode(data.toJson());

class KunjunganResepModel {
  KunjunganResepModel({
    required this.idDokter,
    required this.idKunjungan,
  });

  int idDokter;
  int idKunjungan;

  Map<String, dynamic> toJson() => {
        "idDokter": idDokter,
        "idKunjungan": idKunjungan,
      };
}

ResponseKunjunganResepModel responseKunjunganResepModelFromJson(dynamic str) =>
    ResponseKunjunganResepModel.fromJson(str);

class ResponseKunjunganResepModel {
  ResponseKunjunganResepModel({
    required this.data,
    required this.message,
  });

  List<Resep> data;
  String message;

  factory ResponseKunjunganResepModel.fromJson(Map<String, dynamic> json) =>
      ResponseKunjunganResepModel(
        data: List<Resep>.from(json["data"].map((x) => Resep.fromJson(x))),
        message: json["message"],
      );
}
