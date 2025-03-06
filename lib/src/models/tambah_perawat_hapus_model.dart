import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

TambahPerawatHapusModel tambahPerawatHapusModelFromJson(dynamic str) =>
    TambahPerawatHapusModel.fromJson(str);

class TambahPerawatHapusModel {
  Perawat? data;
  String? message;

  TambahPerawatHapusModel({
    this.data,
    this.message,
  });

  factory TambahPerawatHapusModel.fromJson(Map<String, dynamic> json) =>
      TambahPerawatHapusModel(
        data: json["data"] == null ? null : Perawat.fromJson(json["data"]),
        message: json["message"],
      );
}
