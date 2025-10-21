import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

TambahPerawatModel tambahPerawatModelFromJson(dynamic str) =>
    TambahPerawatModel.fromJson(str);

class TambahPerawatModel {
  List<Perawat>? data;
  String? message;

  TambahPerawatModel({
    this.data,
    this.message,
  });

  factory TambahPerawatModel.fromJson(Map<String, dynamic> json) =>
      TambahPerawatModel(
        data: json["data"] == null
            ? []
            : List<Perawat>.from(json["data"]!.map((x) => Perawat.fromJson(x))),
        message: json["message"],
      );
}

String tambahPerawatRequestModelToJson(TambahPerawatRequestModel data) =>
    json.encode(data.toJson());

class TambahPerawatRequestModel {
  int idPetugas;

  TambahPerawatRequestModel({
    required this.idPetugas,
  });

  Map<String, dynamic> toJson() => {
        "idPetugas": idPetugas,
      };
}
