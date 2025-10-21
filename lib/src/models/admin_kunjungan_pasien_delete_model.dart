import 'package:admin_dokter_panggil/src/models/admin_kunjungan_pasien_model.dart';

AdminKunjunganPasienDeleteModel adminKunjunganPasienDeleteModelFromJson(
        dynamic str) =>
    AdminKunjunganPasienDeleteModel.fromJson(str);

class AdminKunjunganPasienDeleteModel {
  AdminKunjunganPasien? data;
  String? message;

  AdminKunjunganPasienDeleteModel({
    this.data,
    this.message,
  });

  factory AdminKunjunganPasienDeleteModel.fromJson(Map<String, dynamic> json) =>
      AdminKunjunganPasienDeleteModel(
        data: AdminKunjunganPasien.fromJson(json["data"]),
        message: json["message"],
      );
}
