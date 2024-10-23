import 'package:dokter_panggil/src/models/master_identitas_model.dart';

PasienShowModel pasienShowModelFromJson(dynamic str) =>
    PasienShowModel.fromJson(str);

class PasienShowModel {
  PasienShowModel({
    this.pasien,
    this.message,
  });

  Pasien? pasien;
  String? message;

  factory PasienShowModel.fromJson(Map<String, dynamic> json) =>
      PasienShowModel(
        pasien: Pasien.fromJson(json["data"]),
        message: json["message"],
      );
}

class Pasien {
  Pasien({
    this.id,
    this.nik,
    this.identitas,
    this.norm,
    this.normSprint,
    this.namaPasien,
    this.tempatLahir,
    this.tanggalLahir,
    this.umur,
    this.alamat,
    this.jenisKelamin,
    this.jk,
    this.nomorTelepon,
  });

  int? id;
  String? nik;
  IdentitasPasien? identitas;
  String? norm;
  String? normSprint;
  String? namaPasien;
  String? tempatLahir;
  String? tanggalLahir;
  String? umur;
  String? alamat;
  String? jenisKelamin;
  int? jk;
  String? nomorTelepon;

  factory Pasien.fromJson(Map<String, dynamic> json) => Pasien(
        id: json["id"],
        nik: json["nik"] ?? '',
        identitas: json["identitas"] == null
            ? null
            : IdentitasPasien.fromJson(json["identitas"]),
        norm: json["norm"],
        normSprint: json["norm_sprint"],
        namaPasien: json["nama_pasien"],
        tempatLahir: json["tempat_lahir"],
        tanggalLahir: json["tanggal_lahir"],
        umur: json["umur"],
        alamat: json["alamat"],
        jenisKelamin: json["jenis_kelamin"],
        nomorTelepon: json["nomor_telepon"],
        jk: json["jk"],
      );
}

class IdentitasPasien {
  IdentitasPasien({
    this.id,
    this.pasienId,
    this.identitas,
    this.nomorIdentitas,
  });

  int? id;
  int? pasienId;
  MasterIdentitas? identitas;
  String? nomorIdentitas;

  factory IdentitasPasien.fromJson(Map<String, dynamic> json) =>
      IdentitasPasien(
        id: json["id"],
        pasienId: json["pasien_id"],
        identitas: MasterIdentitas.fromJson(json["identitas"]),
        nomorIdentitas: json["nomor_identitas"],
      );
}
