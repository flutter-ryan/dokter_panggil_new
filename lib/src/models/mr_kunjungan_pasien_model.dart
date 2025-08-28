import 'dart:convert';

MrKunjunganPasienModel mrKunjunganPasienModelFromJson(dynamic str) =>
    MrKunjunganPasienModel.fromJson(str);

class MrKunjunganPasienModel {
  Data? data;
  String? message;

  MrKunjunganPasienModel({
    this.data,
    this.message,
  });

  factory MrKunjunganPasienModel.fromJson(Map<String, dynamic> json) =>
      MrKunjunganPasienModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );
}

class Data {
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
  String? dokter;
  String? perawat;
  List<Tindakan>? tindakan;
  List<KunjunganLayanan>? kunjunganLayanan;

  Data({
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
    this.dokter,
    this.perawat,
    this.tindakan,
    this.kunjunganLayanan,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
        dokter: json["dokter"],
        perawat: json["perawat"],
        tindakan: json["tindakan"] == null
            ? []
            : List<Tindakan>.from(
                json["tindakan"]!.map((x) => Tindakan.fromJson(x))),
        kunjunganLayanan: json["kunjungan_layanan"] == null
            ? []
            : List<KunjunganLayanan>.from(json["kunjungan_layanan"]!
                .map((x) => KunjunganLayanan.fromJson(x))),
      );
}

class KunjunganLayanan {
  int? id;
  int? layananId;
  int? kunjunganId;
  String? createdAt;
  String? updatedAt;

  KunjunganLayanan({
    this.id,
    this.layananId,
    this.kunjunganId,
    this.createdAt,
    this.updatedAt,
  });

  factory KunjunganLayanan.fromJson(Map<String, dynamic> json) =>
      KunjunganLayanan(
        id: json["id"],
        layananId: json["layanan_id"],
        kunjunganId: json["kunjungan_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}

class Tindakan {
  int? id;
  int? kunjunganId;
  int? tindakanId;
  String? namaTindakan;
  int? jasaDokter;
  int? tarifAplikasi;

  Tindakan({
    this.id,
    this.kunjunganId,
    this.tindakanId,
    this.namaTindakan,
    this.jasaDokter,
    this.tarifAplikasi,
  });

  factory Tindakan.fromJson(Map<String, dynamic> json) => Tindakan(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        tindakanId: json["tindakan_id"],
        namaTindakan: json["nama_tindakan"],
        jasaDokter: json["jasa_dokter"],
        tarifAplikasi: json["tarif_aplikasi"],
      );
}

String mrKunjunganPasienRequestModelToJson(
        MrKunjunganPasienRequestModel data) =>
    json.encode(data.toJson());

class MrKunjunganPasienRequestModel {
  String norm;
  String tanggal;
  String jam;
  String keluhan;
  int status;
  String dokter;
  String perawat;
  int layanan;
  List<TindakanRequest> tindakan;
  int skrining;
  String resikoJatuh;
  String keputusanResikoJatuh;
  List<String> tokens;
  String namaWali;
  String hubungan;
  String nomorWali;
  int? idRuangan;

  MrKunjunganPasienRequestModel({
    required this.norm,
    required this.tanggal,
    required this.jam,
    required this.keluhan,
    required this.status,
    required this.dokter,
    required this.perawat,
    required this.layanan,
    required this.tindakan,
    required this.skrining,
    required this.resikoJatuh,
    required this.keputusanResikoJatuh,
    required this.tokens,
    required this.namaWali,
    required this.hubungan,
    required this.nomorWali,
    this.idRuangan,
  });

  Map<String, dynamic> toJson() => {
        "norm": norm,
        "tanggal": tanggal,
        "jam": jam,
        "keluhan": keluhan,
        "status": status,
        "dokter": dokter,
        "perawat": perawat,
        "layanan": layanan,
        "tindakan": List<dynamic>.from(tindakan.map((x) => x.toJson())),
        "skrining": skrining,
        "resikoJatuh": resikoJatuh,
        "keputusanResikoJatuh": keputusanResikoJatuh,
        "tokens": List<dynamic>.from(tokens.map((x) => x)),
        "namaWali": namaWali,
        "hubungan": hubungan,
        "nomorWali": nomorWali,
        "idRuangan": idRuangan,
      };
}

class TindakanRequest {
  int idTindakan;
  int jasaDokter;
  int jasaDrp;
  int total;

  TindakanRequest({
    required this.idTindakan,
    required this.jasaDokter,
    required this.jasaDrp,
    required this.total,
  });

  Map<String, dynamic> toJson() => {
        "idTindakan": idTindakan,
        "jasaDokter": jasaDokter,
        "jasaDrp": jasaDrp,
        "total": total,
      };
}

String mrKunjunganPasienPaketRequestModelToJson(
        MrKunjunganPasienPaketRequestModel data) =>
    json.encode(data.toJson());

class MrKunjunganPasienPaketRequestModel {
  String norm;
  String tanggal;
  String jam;
  String keluhan;
  int status;
  String dokter;
  String perawat;
  int layanan;
  int idPaket;
  String namaWali;
  String hubungan;
  String nomorWali;
  int skrining;
  String resikoJatuh;
  String keputusanResikoJatuh;
  List<String> tokens;
  int? idRuangan;

  MrKunjunganPasienPaketRequestModel({
    required this.norm,
    required this.tanggal,
    required this.jam,
    required this.keluhan,
    required this.status,
    required this.dokter,
    required this.perawat,
    required this.layanan,
    required this.idPaket,
    required this.namaWali,
    required this.hubungan,
    required this.nomorWali,
    required this.skrining,
    required this.resikoJatuh,
    required this.keputusanResikoJatuh,
    required this.tokens,
    this.idRuangan,
  });

  Map<String, dynamic> toJson() => {
        "norm": norm,
        "tanggal": tanggal,
        "jam": jam,
        "keluhan": keluhan,
        "status": status,
        "dokter": dokter,
        "perawat": perawat,
        "layanan": layanan,
        "idPaket": idPaket,
        "namaWali": namaWali,
        "hubungan": hubungan,
        "nomorWali": nomorWali,
        "skrining": skrining,
        "resikoJatuh": resikoJatuh,
        "keputusanResikoJatuh": keputusanResikoJatuh,
        "tokens": List<dynamic>.from(tokens.map((x) => x)),
        "idRuangan": idRuangan,
      };
}
