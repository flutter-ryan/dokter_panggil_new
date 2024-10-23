KunjunganRiwayatModel kunjunganRiwayatModelFromJson(dynamic str) =>
    KunjunganRiwayatModel.fromJson(str);

class KunjunganRiwayatModel {
  KunjunganRiwayatModel({
    this.riwayat,
    this.message,
  });

  List<RiwayatKunjungan>? riwayat;
  String? message;

  factory KunjunganRiwayatModel.fromJson(Map<String, dynamic> json) =>
      KunjunganRiwayatModel(
        riwayat: List<RiwayatKunjungan>.from(
            json["data"].map((x) => RiwayatKunjungan.fromJson(x))),
        message: json["message"],
      );
}

class RiwayatKunjungan {
  RiwayatKunjungan({
    this.id,
    this.norm,
    this.normSprint,
    this.namaPasien,
    this.nomorRegistrasi,
    this.tanggal,
    this.keluhan,
  });

  int? id;
  String? norm;
  String? normSprint;
  String? namaPasien;
  String? nomorRegistrasi;
  String? tanggal;
  String? keluhan;

  factory RiwayatKunjungan.fromJson(Map<String, dynamic> json) =>
      RiwayatKunjungan(
        id: json["id"],
        norm: json["norm"],
        normSprint: json["norm_sprint"],
        namaPasien: json["nama_pasien"],
        nomorRegistrasi: json["nomor_registrasi"],
        tanggal: json["tanggal"],
        keluhan: json["keluhan"],
      );
}
