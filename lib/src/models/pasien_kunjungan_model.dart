PasienKunjunganModel pasienKunjunganModelFromJson(dynamic str) =>
    PasienKunjunganModel.fromJson(str);

class PasienKunjunganModel {
  PasienKunjunganModel({
    this.kunjungan,
    this.message,
  });

  List<KunjunganPasien>? kunjungan;
  String? message;

  factory PasienKunjunganModel.fromJson(Map<String, dynamic> json) =>
      PasienKunjunganModel(
        kunjungan: List<KunjunganPasien>.from(json["data"].map(
          (x) => KunjunganPasien.fromJson(x),
        )),
        message: json["message"],
      );
}

class KunjunganPasien {
  KunjunganPasien({
    this.id,
    this.nomorRegistrasi,
    this.tanggal,
    this.keluhan,
    this.dokter,
    this.perawat,
    this.status,
  });

  int? id;
  String? nomorRegistrasi;
  String? tanggal;
  String? keluhan;
  String? dokter;
  String? perawat;
  int? status;

  factory KunjunganPasien.fromJson(Map<String, dynamic> json) =>
      KunjunganPasien(
        id: json["id"],
        nomorRegistrasi: json["nomor_registrasi"],
        tanggal: json["tanggal"],
        keluhan: json["keluhan"],
        dokter: json["dokter"],
        perawat: json["perawat"],
        status: json["status"],
      );
}
