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
    this.layanan,
  });

  int? id;
  String? nomorRegistrasi;
  String? tanggal;
  String? keluhan;
  String? dokter;
  String? perawat;
  int? status;
  List<KunjunganLayanan>? layanan;

  factory KunjunganPasien.fromJson(Map<String, dynamic> json) =>
      KunjunganPasien(
        id: json["id"],
        nomorRegistrasi: json["nomor_registrasi"],
        tanggal: json["tanggal"],
        keluhan: json["keluhan"],
        dokter: json["dokter"],
        perawat: json["perawat"],
        status: json["status"],
        layanan: json["layanan"] == null
            ? []
            : List<KunjunganLayanan>.from(
                json["layanan"]!.map((x) => KunjunganLayanan.fromJson(x))),
      );
}

class KunjunganLayanan {
  int? id;
  int? kunjunganId;
  int? layananId;
  String? namaLayanan;

  KunjunganLayanan({
    this.id,
    this.kunjunganId,
    this.layananId,
    this.namaLayanan,
  });

  factory KunjunganLayanan.fromJson(Map<String, dynamic> json) =>
      KunjunganLayanan(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        layananId: json["layanan_id"],
        namaLayanan: json["nama_layanan"],
      );
}
