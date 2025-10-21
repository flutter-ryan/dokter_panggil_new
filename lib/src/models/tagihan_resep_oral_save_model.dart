import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

TagihanResepOralSaveModel tagihanResepOralSaveModelFromJson(dynamic str) =>
    TagihanResepOralSaveModel.fromJson(str);

class TagihanResepOralSaveModel {
  DetailKunjungan? data;
  String? message;

  TagihanResepOralSaveModel({
    this.data,
    this.message,
  });

  factory TagihanResepOralSaveModel.fromJson(Map<String, dynamic> json) =>
      TagihanResepOralSaveModel(
        data: json["data"] == null
            ? null
            : DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}

String tagihanResepOralRequestModelToJson(TagihanResepOralRequestModel data) =>
    json.encode(data.toJson());

class TagihanResepOralRequestModel {
  List<BarangRequest> barangMitra;
  List<BarangRequest> barangMentari;

  TagihanResepOralRequestModel({
    required this.barangMitra,
    required this.barangMentari,
  });

  Map<String, dynamic> toJson() => {
        "barangMitra": List<dynamic>.from(barangMitra.map((x) => x.toJson())),
        "barangMentari":
            List<dynamic>.from(barangMentari.map((x) => x.toJson())),
      };
}

class BarangRequest {
  int id;
  int jumlah;
  String namaBarang;
  int? tarif;

  BarangRequest({
    required this.id,
    required this.namaBarang,
    required this.jumlah,
    this.tarif,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "jumlah": jumlah,
      };
}
