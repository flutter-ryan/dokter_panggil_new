MrKunjunganAnastesiBedahModel mrKunjunganAnastesiBedahModelFromJson(
        dynamic str) =>
    MrKunjunganAnastesiBedahModel.fromJson(str);

class MrKunjunganAnastesiBedahModel {
  AnastesiBedah? data;
  String? message;

  MrKunjunganAnastesiBedahModel({
    this.data,
    this.message,
  });

  factory MrKunjunganAnastesiBedahModel.fromJson(Map<String, dynamic> json) =>
      MrKunjunganAnastesiBedahModel(
        data:
            json["data"] == null ? null : AnastesiBedah.fromJson(json["data"]),
        message: json["message"],
      );
}

class AnastesiBedah {
  MrKunjunganAnastesi? anastesi;
  MrKunjunganBedah? bedah;

  AnastesiBedah({
    this.anastesi,
    this.bedah,
  });

  factory AnastesiBedah.fromJson(Map<String, dynamic> json) => AnastesiBedah(
        anastesi: json["anastesi"] == null
            ? null
            : MrKunjunganAnastesi.fromJson(json["anastesi"]),
        bedah: json["bedah"] == null
            ? null
            : MrKunjunganBedah.fromJson(json["bedah"]),
      );
}

class MrKunjunganAnastesi {
  int? id;
  int? kunjunganId;
  String? pegawai;
  String? createdAt;
  String? updatedAt;
  String? anastesiUpdatedAt;
  List<Anastesi>? anastesi;

  MrKunjunganAnastesi({
    this.id,
    this.kunjunganId,
    this.pegawai,
    this.anastesi,
    this.createdAt,
    this.updatedAt,
    this.anastesiUpdatedAt,
  });

  factory MrKunjunganAnastesi.fromJson(Map<String, dynamic> json) =>
      MrKunjunganAnastesi(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        pegawai: json["pegawai"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        anastesiUpdatedAt: json["anastesi_updated_at"],
        anastesi: json["anastesi"] == null
            ? []
            : List<Anastesi>.from(
                json["anastesi"]!.map((x) => Anastesi.fromJson(x))),
      );
}

class Anastesi {
  int? id;
  String? jenis;
  String? tanggal;
  String? tekananDarah;
  String? nadi;
  String? pernapasan;
  String? saturasiOksigen;
  String? ncs;
  String? keterangan;

  Anastesi({
    this.id,
    this.jenis,
    this.tanggal,
    this.tekananDarah,
    this.nadi,
    this.pernapasan,
    this.saturasiOksigen,
    this.ncs,
    this.keterangan,
  });

  factory Anastesi.fromJson(Map<String, dynamic> json) => Anastesi(
        id: json["id"],
        jenis: json["jenis"],
        tanggal: json["tanggal"],
        tekananDarah: json["tekanan_darah"],
        nadi: json["nadi"],
        pernapasan: json["pernapasan"],
        saturasiOksigen: json["saturasi_oksigen"],
        ncs: json["ncs"],
        keterangan: json["keterangan"],
      );
}

class MrKunjunganBedah {
  int? id;
  int? kunjunganId;
  String? pegawai;
  String? createdAt;
  String? updatedAt;
  String? bedahUpdatedAt;
  List<Bedah>? bedah;

  MrKunjunganBedah({
    this.id,
    this.kunjunganId,
    this.pegawai,
    this.createdAt,
    this.updatedAt,
    this.bedahUpdatedAt,
    this.bedah,
  });

  factory MrKunjunganBedah.fromJson(Map<String, dynamic> json) =>
      MrKunjunganBedah(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        pegawai: json["pegawai"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        bedahUpdatedAt: json["bedah_updated_at"],
        bedah: json["bedah"] == null
            ? []
            : List<Bedah>.from(json["bedah"]!.map((x) => Bedah.fromJson(x))),
      );
}

class Bedah {
  int? id;
  String? tanggal;
  String? jenis;
  String? subjektif;
  String? objektif;
  String? assesment;
  String? planning;

  Bedah({
    this.id,
    this.tanggal,
    this.jenis,
    this.subjektif,
    this.objektif,
    this.assesment,
    this.planning,
  });

  factory Bedah.fromJson(Map<String, dynamic> json) => Bedah(
        id: json["id"],
        tanggal: json["tanggal"],
        jenis: json["jenis"],
        subjektif: json["subjektif"],
        objektif: json["objektif"],
        assesment: json["assesment"],
        planning: json["planning"],
      );
}
