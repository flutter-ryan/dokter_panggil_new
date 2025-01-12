import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

KwitansiSementaraModel kwitansiSementaraModelFromJson(dynamic str) =>
    KwitansiSementaraModel.fromJson(str);

class KwitansiSementaraModel {
  KwitansiSementara? data;
  String? message;

  KwitansiSementaraModel({
    this.data,
    this.message,
  });

  factory KwitansiSementaraModel.fromJson(Map<String, dynamic> json) =>
      KwitansiSementaraModel(
        data: json["data"] == null
            ? null
            : KwitansiSementara.fromJson(json["data"]),
        message: json["message"],
      );
}

class KwitansiSementara {
  int? id;
  int? kunjunganId;
  Pasien? pasien;
  String? url;

  KwitansiSementara({
    this.id,
    this.pasien,
    this.kunjunganId,
    this.url,
  });

  factory KwitansiSementara.fromJson(Map<String, dynamic> json) =>
      KwitansiSementara(
        id: json["id"],
        pasien: json["pasien"] == null ? null : Pasien.fromJson(json["pasien"]),
        kunjunganId: json["kunjungan_id"],
        url: json["url"],
      );
}
