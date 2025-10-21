import 'package:admin_dokter_panggil/src/models/pendaftaran_kunjungan_save_model.dart';

KunjunganPasienAllModel kunjunganPasienAllModelFromJson(dynamic str) =>
    KunjunganPasienAllModel.fromJson(str);

class KunjunganPasienAllModel {
  KunjunganPasienAllModel({
    this.data,
    this.currentPage,
    this.totalPage,
    this.message,
  });

  List<Kunjungan>? data;
  int? currentPage;
  int? totalPage;
  String? message;

  factory KunjunganPasienAllModel.fromJson(Map<String, dynamic> json) =>
      KunjunganPasienAllModel(
        data: List<Kunjungan>.from(
            json["data"].map((x) => Kunjungan.fromJson(x))),
        currentPage: json["current_page"],
        totalPage: json["totalPage"],
        message: json["message"],
      );
}
