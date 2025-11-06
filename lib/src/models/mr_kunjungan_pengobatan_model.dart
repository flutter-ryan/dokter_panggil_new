MrKunjunganPengobatanModel mrKunjunganPengobatanModelFromJson(dynamic str) =>
    MrKunjunganPengobatanModel.fromJson(str);

class MrKunjunganPengobatanModel {
  List<MrKunjunganPengobatan>? data;
  String? message;

  MrKunjunganPengobatanModel({
    this.data,
    this.message,
  });

  factory MrKunjunganPengobatanModel.fromJson(Map<String, dynamic> json) =>
      MrKunjunganPengobatanModel(
        data: json["data"] == null
            ? []
            : List<MrKunjunganPengobatan>.from(
                json["data"]!.map((x) => MrKunjunganPengobatan.fromJson(x))),
        message: json["message"],
      );
}

class MrKunjunganPengobatan {
  int? id;
  int? kunjunganId;
  int? pegawaiId;
  String? namaPegawai;
  String? tanggalMulai;
  String? stopAt;
  bool? isInjeksi;
  bool? isOral;
  bool? isRacikan;
  Pengobatan? pengobatan;
  List<TimelinePengobatan>? timeline;

  MrKunjunganPengobatan({
    this.id,
    this.kunjunganId,
    this.pegawaiId,
    this.namaPegawai,
    this.tanggalMulai,
    this.stopAt,
    this.isInjeksi,
    this.isOral,
    this.isRacikan,
    this.pengobatan,
    this.timeline,
  });

  factory MrKunjunganPengobatan.fromJson(Map<String, dynamic> json) =>
      MrKunjunganPengobatan(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        pegawaiId: json["pegawai_id"],
        namaPegawai: json["nama_pegawai"],
        tanggalMulai: json["tanggal_mulai"],
        stopAt: json["stop_at"],
        isInjeksi: json["is_injeksi"],
        isOral: json["is_oral"],
        isRacikan: json["is_racikan"],
        pengobatan: json["pengobatan"] == null
            ? null
            : Pengobatan.fromJson(json["pengobatan"]),
        timeline: json["timeline"] == null
            ? []
            : List<TimelinePengobatan>.from(
                json["timeline"].map((x) => TimelinePengobatan.fromJson(x)),
              ),
      );
}

class Pengobatan {
  int? id;
  String? namaObat;
  String? dosis;
  String? rute;
  List<TanggalPemberian>? tanggalPemberian;

  Pengobatan({
    this.id,
    this.namaObat,
    this.dosis,
    this.rute,
    this.tanggalPemberian,
  });

  factory Pengobatan.fromJson(Map<String, dynamic> json) => Pengobatan(
        id: json["id"],
        namaObat: json["nama_obat"],
        dosis: json["dosis"],
        rute: json["rute"],
        tanggalPemberian: json["tanggal_pemberian"] == null
            ? []
            : List<TanggalPemberian>.from(json["tanggal_pemberian"]!
                .map((x) => TanggalPemberian.fromJson(x))),
      );
}

class TanggalPemberian {
  String? namaPegawai;
  String? tanggal;

  TanggalPemberian({
    this.namaPegawai,
    this.tanggal,
  });

  factory TanggalPemberian.fromJson(Map<String, dynamic> json) =>
      TanggalPemberian(
        namaPegawai: json["nama_pegawai"],
        tanggal: json["tanggal"],
      );
}

class TimelinePengobatan {
  int? id;
  int? kunjunganPengobatanId;
  int? pegawaiId;
  String? namaPegawai;
  String? pengobatanAt;

  TimelinePengobatan({
    this.id,
    this.kunjunganPengobatanId,
    this.pegawaiId,
    this.namaPegawai,
    this.pengobatanAt,
  });

  factory TimelinePengobatan.fromJson(Map<String, dynamic> json) =>
      TimelinePengobatan(
        id: json["id"],
        kunjunganPengobatanId: json["kunjungan_pengobatan_id"],
        pegawaiId: json["pegawai_id"],
        namaPegawai: json["nama_pegawai"],
        pengobatanAt: json["pengobatan_at"],
      );
}
