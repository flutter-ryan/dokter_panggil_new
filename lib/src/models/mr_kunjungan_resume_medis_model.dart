MrKunjunganResumeMedisModel mrKunjunganResumeMedisModelFromJson(dynamic str) =>
    MrKunjunganResumeMedisModel.fromJson(str);

class MrKunjunganResumeMedisModel {
  DataResumeMedis? data;
  String? message;

  MrKunjunganResumeMedisModel({
    this.data,
    this.message,
  });

  factory MrKunjunganResumeMedisModel.fromJson(Map<String, dynamic> json) =>
      MrKunjunganResumeMedisModel(
        data: json["data"] == null
            ? null
            : DataResumeMedis.fromJson(json["data"]),
        message: json["message"],
      );
}

class DataResumeMedis {
  int? id;
  String? tanggalLayanan;
  bool? isPerawat;
  bool? isDokter;
  int? kunjunganId;
  int? pegawaiId;
  String? namaPegawai;
  String? diagnosisMasuk;
  String? ringkasanRiwayatPenyakit;
  String? ringkasanPemeriksaanFisik;
  dynamic ringkasanRiwayatPenunjang;
  String? riwayatAlergi;
  String? tanggalKontrol;
  List<Icd10>? icd10;
  List<Icd9>? icd9;
  String? terapiSelamaHomecare;
  String? instruksiTindakLanjut;
  String? terapiPerluLanjut;
  String? createdAt;
  String? updatedAt;
  bool? isUpdate;
  bool? canEdit;

  DataResumeMedis({
    this.id,
    this.tanggalLayanan,
    this.isPerawat,
    this.isDokter,
    this.kunjunganId,
    this.pegawaiId,
    this.namaPegawai,
    this.diagnosisMasuk,
    this.ringkasanRiwayatPenyakit,
    this.ringkasanPemeriksaanFisik,
    this.ringkasanRiwayatPenunjang,
    this.riwayatAlergi,
    this.tanggalKontrol,
    this.icd10,
    this.icd9,
    this.terapiSelamaHomecare,
    this.instruksiTindakLanjut,
    this.terapiPerluLanjut,
    this.createdAt,
    this.updatedAt,
    this.isUpdate,
    this.canEdit,
  });

  factory DataResumeMedis.fromJson(Map<String, dynamic> json) =>
      DataResumeMedis(
        id: json["id"],
        tanggalLayanan: json["tanggal_layanan"],
        isPerawat: json["is_perawat"],
        isDokter: json["is_dokter"],
        kunjunganId: json["kunjungan_id"],
        pegawaiId: json["pegawai_id"],
        namaPegawai: json["nama_pegawai"],
        diagnosisMasuk: json["diagnosis_masuk"],
        ringkasanRiwayatPenyakit: json["ringkasan_riwayat_penyakit"],
        ringkasanPemeriksaanFisik: json["ringkasan_pemeriksaan_fisik"],
        ringkasanRiwayatPenunjang: json["ringkasan_riwayat_penunjang"],
        riwayatAlergi: json["riwayat_alergi"],
        tanggalKontrol: json["tanggal_kontrol"],
        icd10: json["icd_10"] == null
            ? []
            : List<Icd10>.from(json["icd_10"]!.map((x) => Icd10.fromJson(x))),
        icd9: json["icd_9"] == null
            ? []
            : List<Icd9>.from(json["icd_9"]!.map((x) => Icd9.fromJson(x))),
        terapiSelamaHomecare: json["terapi_selama_homecare"],
        instruksiTindakLanjut: json["instruksi_tindak_lanjut"],
        terapiPerluLanjut: json["terapi_perlu_lanjut"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isUpdate: json["is_update"],
        canEdit: json["can_edit"],
      );
}

class Icd10 {
  int? id;
  String? namaDiagnosa;
  String? kodeIcd10;
  String? type;

  Icd10({
    this.id,
    this.namaDiagnosa,
    this.kodeIcd10,
    this.type,
  });

  factory Icd10.fromJson(Map<String, dynamic> json) => Icd10(
        id: json["id"],
        namaDiagnosa: json["namaDiagnosa"],
        kodeIcd10: json["kodeIcd10"],
        type: json["type"],
      );
}

class Icd9 {
  int? id;
  String? namaDiagnosa;
  String? kodeIcd9;
  String? type;

  Icd9({
    this.id,
    this.namaDiagnosa,
    this.kodeIcd9,
    this.type,
  });

  factory Icd9.fromJson(Map<String, dynamic> json) => Icd9(
        id: json["id"],
        namaDiagnosa: json["namaDiagnosa"],
        kodeIcd9: json["kodeIcd9"],
        type: json["type"],
      );
}
