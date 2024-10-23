import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String kunjunganResepRacikanModelToJson(KunjunganResepRacikanModel data) =>
    json.encode(data.toJson());

class KunjunganResepRacikanModel {
  KunjunganResepRacikanModel({
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

ResponseKunjunganResepRacikanModel responseKunjunganResepRacikanModelFromJson(
        dynamic str) =>
    ResponseKunjunganResepRacikanModel.fromJson(str);

class ResponseKunjunganResepRacikanModel {
  ResponseKunjunganResepRacikanModel({
    required this.data,
    required this.message,
  });

  List<ResepRacikan> data;
  String message;

  factory ResponseKunjunganResepRacikanModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseKunjunganResepRacikanModel(
        data: List<ResepRacikan>.from(
            json["data"].map((x) => ResepRacikan.fromJson(x))),
        message: json["message"],
      );
}
