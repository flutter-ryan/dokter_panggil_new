import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

TagihanResepRacikanSaveModel tagihanResepRacikanSaveModelFromJson(
        dynamic str) =>
    TagihanResepRacikanSaveModel.fromJson(str);

class TagihanResepRacikanSaveModel {
  DetailKunjungan? data;
  String? message;

  TagihanResepRacikanSaveModel({
    this.data,
    this.message,
  });

  factory TagihanResepRacikanSaveModel.fromJson(Map<String, dynamic> json) =>
      TagihanResepRacikanSaveModel(
        data: json["data"] == null
            ? null
            : DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}

String tagihanResepRacikanRequestModelToJson(
        TagihanResepRacikanRequestModel data) =>
    json.encode(data.toJson());

class TagihanResepRacikanRequestModel {
  List<BarangRacikanRequest> barangMitra;
  List<BarangRacikanRequest> barangMentari;

  TagihanResepRacikanRequestModel({
    required this.barangMitra,
    required this.barangMentari,
  });

  Map<String, dynamic> toJson() => {
        "barangMitra": List<dynamic>.from(barangMitra.map((x) => x.toJson())),
        "barangMentari": List<dynamic>.from(barangMentari.map((x) => x)),
      };
}

class BarangRacikanRequest {
  int id;
  String? namaBarang;
  int jumlah;
  int? tarif;

  BarangRacikanRequest({
    required this.id,
    this.namaBarang,
    required this.jumlah,
    this.tarif,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "jumlah": jumlah,
      };
}
