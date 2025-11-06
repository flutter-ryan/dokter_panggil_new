MrHasilLabModel mrHasilLabModelFromJson(dynamic str) =>
    MrHasilLabModel.fromJson(str);

class MrHasilLabModel {
  List<DataMrHasilLab>? data;
  String? message;

  MrHasilLabModel({
    this.data,
    this.message,
  });

  factory MrHasilLabModel.fromJson(Map<String, dynamic> json) =>
      MrHasilLabModel(
        data: json["data"] == null
            ? []
            : List<DataMrHasilLab>.from(
                json["data"]!.map((x) => DataMrHasilLab.fromJson(x))),
        message: json["message"],
      );
}

class DataMrHasilLab {
  int? id;
  String? tanggalPengantar;
  List<DokumenLabRiwayat>? hasilLab;
  int? kunjunganId;
  int? pegawaiId;
  String? namaPegawai;
  List<HasilLabTindakan>? tindakanLab;

  DataMrHasilLab({
    this.id,
    this.tanggalPengantar,
    this.hasilLab,
    this.kunjunganId,
    this.pegawaiId,
    this.namaPegawai,
    this.tindakanLab,
  });

  factory DataMrHasilLab.fromJson(Map<String, dynamic> json) => DataMrHasilLab(
        id: json["id"],
        tanggalPengantar: json["tanggal_pengantar"],
        hasilLab: json["hasil_lab"] == null
            ? []
            : List<DokumenLabRiwayat>.from(
                json["hasil_lab"]!.map((x) => DokumenLabRiwayat.fromJson(x))),
        kunjunganId: json["kunjungan_id"],
        pegawaiId: json["pegawai_id"],
        namaPegawai: json["nama_pegawai"],
        tindakanLab: json["tindakan_lab"] == null
            ? []
            : List<HasilLabTindakan>.from(
                json["tindakan_lab"]!.map((x) => HasilLabTindakan.fromJson(x))),
      );
}

class HasilLabTindakan {
  int? id;
  int? pegawaiId;
  String? tindakanLab;

  HasilLabTindakan({
    this.id,
    this.pegawaiId,
    this.tindakanLab,
  });

  factory HasilLabTindakan.fromJson(Map<String, dynamic> json) =>
      HasilLabTindakan(
        id: json["id"],
        pegawaiId: json["pegawai_id"],
        tindakanLab: json["tindakan_lab"],
      );
}

class DokumenLabRiwayat {
  int? id;
  int? pengantarId;
  String? namaFile;
  PasienDokumenRiwayat? pasien;
  String? url;
  String? extension;
  String? createdAt;
  String? confirmedAt;
  String? confirmedBy;
  bool? verifikator;

  DokumenLabRiwayat({
    this.id,
    this.pengantarId,
    this.pasien,
    this.namaFile,
    this.url,
    this.extension,
    this.createdAt,
    this.confirmedAt,
    this.confirmedBy,
    this.verifikator,
  });

  factory DokumenLabRiwayat.fromJson(Map<String, dynamic> json) =>
      DokumenLabRiwayat(
        id: json["id"],
        pengantarId: json["pengantar_id"],
        pasien: PasienDokumenRiwayat.fromJson(json["pasien"]),
        namaFile: json["nama_file"],
        url: json["url"],
        extension: json["extension"],
        createdAt: json["created_at"],
        confirmedAt: json["confirmed_at"],
        confirmedBy: json["confirmed_by"],
        verifikator: json["verifikator"],
      );
}

class PasienDokumenRiwayat {
  int? id;
  String? norm;
  String? namaPasien;

  PasienDokumenRiwayat({
    this.id,
    this.norm,
    this.namaPasien,
  });

  factory PasienDokumenRiwayat.fromJson(Map<String, dynamic> json) =>
      PasienDokumenRiwayat(
        id: json["id"],
        norm: json["norm"],
        namaPasien: json["nama_pasien"],
      );
}
