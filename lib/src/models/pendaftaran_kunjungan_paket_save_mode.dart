import 'dart:convert';

import 'package:dokter_panggil/src/models/pendaftaran_kunjungan_save_model.dart';

String pendaftaranKunjunganPaketSaveModelToJson(
        PendaftaranKunjunganPaketSaveModel data) =>
    json.encode(data.toJson());

class PendaftaranKunjunganPaketSaveModel {
  PendaftaranKunjunganPaketSaveModel({
    required this.norm,
    required this.tanggal,
    required this.jam,
    required this.idPaket,
    required this.dokter,
    required this.perawat,
    required this.status,
    required this.tokens,
  });

  String norm;
  String tanggal;
  String jam;
  int idPaket;
  String dokter;
  String perawat;
  int status;
  List<String> tokens;

  Map<String, dynamic> toJson() => {
        "norm": norm,
        "tanggal": tanggal,
        "jam": jam,
        "idPaket": idPaket,
        "dokter": dokter,
        "perawat": perawat,
        "status": status,
        "tokens": tokens,
      };
}

ResponsePendaftaranKunjunganPaketSaveModel
    responsePendaftaranKunjunganPaketSaveModelFromJson(dynamic str) =>
        ResponsePendaftaranKunjunganPaketSaveModel.fromJson(str);

class ResponsePendaftaranKunjunganPaketSaveModel {
  ResponsePendaftaranKunjunganPaketSaveModel({
    this.data,
    this.message,
  });

  Kunjungan? data;
  String? message;

  factory ResponsePendaftaranKunjunganPaketSaveModel.fromJson(
          Map<String, dynamic> json) =>
      ResponsePendaftaranKunjunganPaketSaveModel(
        data: Kunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
