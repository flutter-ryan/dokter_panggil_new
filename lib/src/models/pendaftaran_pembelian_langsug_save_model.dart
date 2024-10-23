import 'dart:convert';

import 'package:dokter_panggil/src/models/pendaftaran_kunjungan_save_model.dart';

String pendaftaranPembelianLangsungSaveModelToJson(
        PendaftaranPembelianLangsungSaveModel data) =>
    json.encode(data.toJson());

class PendaftaranPembelianLangsungSaveModel {
  PendaftaranPembelianLangsungSaveModel({
    required this.norm,
    required this.tanggal,
    required this.jam,
    required this.drugs,
    required this.consumes,
    required this.jumlahDrugs,
    required this.jumlahConsumes,
    required this.hargaModalDrugs,
    required this.hargaModalConsumes,
    required this.tarifAplikasiDrugs,
    required this.tarifAplikasiConsumes,
    required this.aturan,
    required this.catatan,
    required this.status,
  });

  String norm;
  String tanggal;
  String jam;
  List<int> drugs;
  List<int> consumes;
  List<int> jumlahDrugs;
  List<int> jumlahConsumes;
  List<int> hargaModalDrugs;
  List<int> hargaModalConsumes;
  List<int> tarifAplikasiDrugs;
  List<int> tarifAplikasiConsumes;
  List<String> aturan;
  List<String> catatan;
  int status;

  Map<String, dynamic> toJson() => {
        "norm": norm,
        "tanggal": tanggal,
        "jam": jam,
        "drugs": List<int>.from(drugs.map((x) => x)),
        "consumes": List<int>.from(consumes.map((x) => x)),
        "jumlahDrugs": List<int>.from(jumlahDrugs.map((x) => x)),
        "jumlahConsumes": List<int>.from(jumlahConsumes.map((x) => x)),
        "hargaModalDrugs": List<int>.from(hargaModalDrugs.map((x) => x)),
        "hargaModalConsumes": List<int>.from(hargaModalConsumes.map((x) => x)),
        "tarifAplikasiDrugs": List<int>.from(tarifAplikasiDrugs.map((x) => x)),
        "tarifAplikasiConsumes":
            List<int>.from(tarifAplikasiConsumes.map((x) => x)),
        "aturan": List<String>.from(aturan.map((x) => x)),
        "catatan": List<String>.from(catatan.map((x) => x)),
        "status": status,
      };
}

ResponsePendaftaranPembelianLangsungSaveModel
    responsePendaftaranPembelianLangsungSaveModelFromJson(dynamic str) =>
        ResponsePendaftaranPembelianLangsungSaveModel.fromJson(str);

class ResponsePendaftaranPembelianLangsungSaveModel {
  ResponsePendaftaranPembelianLangsungSaveModel({
    this.data,
    this.message,
  });

  Kunjungan? data;
  String? message;

  factory ResponsePendaftaranPembelianLangsungSaveModel.fromJson(
          Map<String, dynamic> json) =>
      ResponsePendaftaranPembelianLangsungSaveModel(
        data: Kunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}
