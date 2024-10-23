import 'dart:convert';

import 'package:dokter_panggil/src/models/pendaftaran_kunjungan_save_model.dart';

String pendaftaranKunjunganNonkonsulSaveModelToJson(
        PendaftaranKunjunganNonkonsulSaveModel? data) =>
    json.encode(data!.toJson());

class PendaftaranKunjunganNonkonsulSaveModel {
  PendaftaranKunjunganNonkonsulSaveModel({
    required this.norm,
    required this.tanggal,
    required this.jam,
    required this.tindakanLab,
    required this.hargaModal,
    required this.tarifAplikasi,
    required this.perawat,
    required this.status,
    required this.tokens,
  });

  String norm;
  String tanggal;
  String jam;
  List<int> tindakanLab;
  List<int> hargaModal;
  List<int> tarifAplikasi;
  int perawat;
  int status;
  List<String> tokens;

  Map<String, dynamic> toJson() => {
        "norm": norm,
        "tanggal": tanggal,
        "jam": jam,
        "tindakanLab": List<dynamic>.from(tindakanLab.map((x) => x)),
        "hargaModal": List<dynamic>.from(hargaModal.map((x) => x)),
        "tarifAplikasi": List<dynamic>.from(tarifAplikasi.map((x) => x)),
        "perawat": perawat,
        "status": status,
        "tokens": tokens,
      };
}

ResponsePendaftaranKunjunganNonkonsulSaveModel
    responsePendaftaranKunjunganNonkonsulSaveModelFromJson(dynamic str) =>
        ResponsePendaftaranKunjunganNonkonsulSaveModel.fromJson(str);

class ResponsePendaftaranKunjunganNonkonsulSaveModel {
  ResponsePendaftaranKunjunganNonkonsulSaveModel({
    this.data,
    this.message,
  });

  Kunjungan? data;
  String? message;

  factory ResponsePendaftaranKunjunganNonkonsulSaveModel.fromJson(
          Map<String, dynamic> json) =>
      ResponsePendaftaranKunjunganNonkonsulSaveModel(
        data: Kunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
