RiwayatResumePasienModel riwayatResumePasienModelFromJson(dynamic str) =>
    RiwayatResumePasienModel.fromJson(str);

class RiwayatResumePasienModel {
  List<RiwayatResume>? data;
  int? currentPage;
  int? totalPage;
  String? message;

  RiwayatResumePasienModel({
    this.data,
    this.currentPage,
    this.totalPage,
    this.message,
  });

  factory RiwayatResumePasienModel.fromJson(Map<String, dynamic> json) =>
      RiwayatResumePasienModel(
        data: List<RiwayatResume>.from(
            json["data"].map((x) => RiwayatResume.fromJson(x))),
        currentPage: json["current_page"],
        totalPage: json["totalPage"],
        message: json["message"],
      );
}

class RiwayatResume {
  int? id;
  String? nomorRegistrasi;
  String? norm;
  String? tanggalKunjungan;
  String? keluhan;
  String? dokter;
  String? perawat;
  String? diagnosa;

  RiwayatResume({
    this.id,
    this.nomorRegistrasi,
    this.norm,
    this.tanggalKunjungan,
    this.keluhan,
    this.dokter,
    this.perawat,
    this.diagnosa,
  });

  factory RiwayatResume.fromJson(Map<String, dynamic> json) => RiwayatResume(
        id: json["id"],
        nomorRegistrasi: json["nomor_registrasi"],
        norm: json["norm"],
        tanggalKunjungan: json["full_tanggal"],
        keluhan: json["keluhan"],
        dokter: json["dokter"],
        perawat: json["perawat"],
        diagnosa: json["diagnosa"],
      );
}
