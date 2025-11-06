import 'package:admin_dokter_panggil/src/models/master_identitas_model.dart';
import 'package:admin_dokter_panggil/src/models/master_village_model.dart';

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
    this.idSatuSehat,
    this.pasienKontakDarurat,
    this.pasienStatusPerkawinan,
    this.pasienAdministrativeCode,
    this.isDewasa = true,
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
  String? idSatuSehat;
  PasienKontakDarurat? pasienKontakDarurat;
  PasienStatusPerkawinan? pasienStatusPerkawinan;
  PasienAdministrativeCode? pasienAdministrativeCode;
  bool isDewasa;

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
        idSatuSehat: json["id_satu_sehat"],
        pasienKontakDarurat: json["kontak_darurat"] == null
            ? null
            : PasienKontakDarurat.fromJson(json["kontak_darurat"]),
        pasienStatusPerkawinan: json["status_perkawinan"] == null
            ? null
            : PasienStatusPerkawinan.fromJson(json["status_perkawinan"]),
        pasienAdministrativeCode: json["administrative_code"] == null
            ? null
            : PasienAdministrativeCode.fromJson(json["administrative_code"]),
        isDewasa: json["is_dewasa"],
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

class PasienKontakDarurat {
  int? id;
  String? nama;
  String? nomorKontak;

  PasienKontakDarurat({
    this.id,
    this.nama,
    this.nomorKontak,
  });

  factory PasienKontakDarurat.fromJson(Map<String, dynamic> json) =>
      PasienKontakDarurat(
        id: json["id"],
        nama: json["nama"],
        nomorKontak: json["nomor_kontak"],
      );
}

class PasienStatusPerkawinan {
  int? id;
  int? statusId;
  String? statusDeskripsi;

  PasienStatusPerkawinan({
    this.id,
    this.statusId,
    this.statusDeskripsi,
  });

  factory PasienStatusPerkawinan.fromJson(Map<String, dynamic> json) =>
      PasienStatusPerkawinan(
        id: json["id"],
        statusId: json["status_id"],
        statusDeskripsi: json["status_deskripsi"],
      );
}

class PasienAdministrativeCode {
  int? id;
  Village? village;
  String? kodePos;
  String? rt;
  String? rw;

  PasienAdministrativeCode({
    this.id,
    this.village,
    this.kodePos,
    this.rt,
    this.rw,
  });

  factory PasienAdministrativeCode.fromJson(Map<String, dynamic> json) =>
      PasienAdministrativeCode(
        id: json["id"],
        village:
            json["village"] == null ? null : Village.fromJson(json["village"]),
        kodePos: json["kode_pos"],
        rt: json["rt"],
        rw: json["rw"],
      );
}
