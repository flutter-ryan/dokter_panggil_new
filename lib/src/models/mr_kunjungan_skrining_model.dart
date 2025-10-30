MrKunjunganSkriningModel mrKunjunganSkriningModelFromJson(dynamic str) =>
    MrKunjunganSkriningModel.fromJson(str);

class MrKunjunganSkriningModel {
  MrKunjunganSkrining? data;
  String? message;

  MrKunjunganSkriningModel({
    this.data,
    this.message,
  });

  factory MrKunjunganSkriningModel.fromJson(Map<String, dynamic> json) =>
      MrKunjunganSkriningModel(
        data: json["data"] == null
            ? null
            : MrKunjunganSkrining.fromJson(json["data"]),
        message: json["message"],
      );
}

class MrKunjunganSkrining {
  int? id;
  String? nomorRegistrasi;
  SkriningPasien? skriningPasien;

  MrKunjunganSkrining({
    this.id,
    this.nomorRegistrasi,
    this.skriningPasien,
  });

  factory MrKunjunganSkrining.fromJson(Map<String, dynamic> json) =>
      MrKunjunganSkrining(
        id: json["id"],
        nomorRegistrasi: json["nomor_registrasi"],
        skriningPasien: json["skrining_pasien"] == null
            ? null
            : SkriningPasien.fromJson(json["skrining_pasien"]),
      );
}

class SkriningPasien {
  int? id;
  int? kunjunganId;
  int? pegawaiId;
  String? resikoJatuh;
  String? keputusanResikoJatuh;
  WaliPasien? waliPasien;
  PasienSkrining? pasienSkrining;
  Skrining? skrining;

  SkriningPasien({
    this.id,
    this.kunjunganId,
    this.pegawaiId,
    this.resikoJatuh,
    this.keputusanResikoJatuh,
    this.waliPasien,
    this.pasienSkrining,
    this.skrining,
  });

  factory SkriningPasien.fromJson(Map<String, dynamic> json) => SkriningPasien(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        pegawaiId: json["pegawai_id"],
        resikoJatuh: json["resiko_jatuh"],
        keputusanResikoJatuh: json["keputusan_resiko_jatuh"],
        pasienSkrining: json["pasien"] == null
            ? null
            : PasienSkrining.fromJson(json["pasien"]),
        waliPasien: json["wali_pasien"] == null
            ? null
            : WaliPasien.fromJson(json["wali_pasien"]),
        skrining: json["skrining"] == null
            ? null
            : Skrining.fromJson(json["skrining"]),
      );
}

class Skrining {
  int? id;
  String? skrining;
  String? warna;
  String? keputusan;

  Skrining({
    this.id,
    this.skrining,
    this.warna,
    this.keputusan,
  });

  factory Skrining.fromJson(Map<String, dynamic> json) => Skrining(
        id: json["id"],
        skrining: json["skrining"],
        warna: json["warna"],
        keputusan: json["keputusan"],
      );
}

class PasienSkrining {
  int? id;
  dynamic nik;
  String? normSprint;
  String? namaPasien;
  String? umur;
  String? alamat;
  int? jenisKelamin;
  String? nomorTelepon;
  String? tanggalLahir;

  PasienSkrining({
    this.id,
    this.nik,
    this.normSprint,
    this.namaPasien,
    this.umur,
    this.alamat,
    this.jenisKelamin,
    this.nomorTelepon,
    this.tanggalLahir,
  });

  factory PasienSkrining.fromJson(Map<String, dynamic> json) => PasienSkrining(
        id: json["id"],
        nik: json["nik"],
        normSprint: json["norm_sprint"],
        namaPasien: json["nama_pasien"],
        umur: json["umur"],
        alamat: json["alamat"],
        jenisKelamin: json["jenis_kelamin"],
        nomorTelepon: json["nomor_telepon"],
        tanggalLahir: json["tanggal_lahir"],
      );
}

class WaliPasien {
  dynamic id;
  String? namaWali;
  String? hubungan;
  dynamic nomorKontak;

  WaliPasien({
    this.id,
    this.namaWali,
    this.hubungan,
    this.nomorKontak,
  });

  factory WaliPasien.fromJson(Map<String, dynamic> json) => WaliPasien(
        id: json["id"],
        namaWali: json["nama_wali"],
        hubungan: json["hubungan"],
        nomorKontak: json["nomor_kontak"],
      );
}
