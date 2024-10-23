import 'dart:convert';

String kunjunganEresepCreateModelToJson(KunjunganEresepCreateModel data) =>
    json.encode(data.toJson());

class KunjunganEresepCreateModel {
  int idPegawai;
  int idKunjungan;

  KunjunganEresepCreateModel({
    required this.idPegawai,
    required this.idKunjungan,
  });

  Map<String, dynamic> toJson() => {
        "idPegawai": idPegawai,
        "idKunjungan": idKunjungan,
      };
}
