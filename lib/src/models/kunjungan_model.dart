import 'package:admin_dokter_panggil/src/models/pendaftaran_kunjungan_save_model.dart';

KunjunganModel kunjunganModelFromJson(dynamic str) =>
    KunjunganModel.fromJson(str);

class KunjunganModel {
  KunjunganModel({
    this.kunjungan,
    this.message,
  });

  List<Kunjungan>? kunjungan;
  String? message;

  factory KunjunganModel.fromJson(Map<String, dynamic> json) => KunjunganModel(
        kunjungan: List<Kunjungan>.from(
            json["data"].map((x) => Kunjungan.fromJson(x))),
        message: json["message"],
      );
}
