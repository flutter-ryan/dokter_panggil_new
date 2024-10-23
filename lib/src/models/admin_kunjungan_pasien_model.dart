import 'dart:convert';

AdminKunjunganPasienModel adminKunjunganPasienModelFromJson(dynamic str) =>
    AdminKunjunganPasienModel.fromJson(str);

class AdminKunjunganPasienModel {
  List<AdminKunjunganPasien>? data;
  int? currentPage;
  int? totalPage;
  String? message;
  int? total;

  AdminKunjunganPasienModel({
    this.data,
    this.currentPage,
    this.totalPage,
    this.message,
    this.total,
  });

  factory AdminKunjunganPasienModel.fromJson(Map<String, dynamic> json) =>
      AdminKunjunganPasienModel(
        data: List<AdminKunjunganPasien>.from(
            json["data"]!.map((x) => AdminKunjunganPasien.fromJson(x))),
        currentPage: json["current_page"],
        totalPage: json["totalPage"],
        message: json["message"],
        total: json["total"],
      );
}

class AdminKunjunganPasien {
  int? id;
  String? namaPasien;
  String? norm;
  String? normSprint;
  String? nomorRegistrasi;
  String? tanggal;
  String? jam;
  String? fullTanggal;
  String? keluhan;
  int? status;
  int? isTagihan;

  AdminKunjunganPasien({
    this.id,
    this.namaPasien,
    this.norm,
    this.normSprint,
    this.nomorRegistrasi,
    this.tanggal,
    this.jam,
    this.fullTanggal,
    this.keluhan,
    this.status,
    this.isTagihan,
  });

  factory AdminKunjunganPasien.fromJson(Map<String, dynamic> json) =>
      AdminKunjunganPasien(
        id: json["id"],
        namaPasien: json["nama_pasien"],
        norm: json["norm"],
        normSprint: json["norm_sprint"],
        nomorRegistrasi: json["nomor_registrasi"],
        tanggal: json["tanggal"],
        jam: json["jam"],
        fullTanggal: json["full_tanggal"],
        keluhan: json["keluhan"],
        status: json["status"],
        isTagihan: json["is_tagihan"],
      );
}

String kirimAdminKunjunganPasienModelToJson(
        KirimAdminKunjunganPasienModel data) =>
    json.encode(data.toJson());

class KirimAdminKunjunganPasienModel {
  String? filter;
  KirimAdminKunjunganPasienModel({
    required this.filter,
  });

  Map<String, dynamic> toJson() => {
        "filter": filter,
      };
}
