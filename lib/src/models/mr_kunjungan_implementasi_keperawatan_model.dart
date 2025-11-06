MrKunjunganImplementasiKeperawatanModel
    mrKunjunganImplementasiKeperawatanModelFromJson(dynamic str) =>
        MrKunjunganImplementasiKeperawatanModel.fromJson(str);

class MrKunjunganImplementasiKeperawatanModel {
  DataImplementasiKeperawatan? data;
  String? message;

  MrKunjunganImplementasiKeperawatanModel({
    this.data,
    this.message,
  });

  factory MrKunjunganImplementasiKeperawatanModel.fromJson(
          Map<String, dynamic> json) =>
      MrKunjunganImplementasiKeperawatanModel(
        data: json["data"] == null
            ? null
            : DataImplementasiKeperawatan.fromJson(json["data"]),
        message: json["message"],
      );
}

class DataImplementasiKeperawatan {
  int? id;
  String? nomorRegistrasi;
  String? petugas;
  List<Implementasi>? implementasi;

  DataImplementasiKeperawatan({
    this.id,
    this.nomorRegistrasi,
    this.petugas,
    this.implementasi,
  });

  factory DataImplementasiKeperawatan.fromJson(Map<String, dynamic> json) =>
      DataImplementasiKeperawatan(
        id: json["id"],
        nomorRegistrasi: json["nomor_registrasi"],
        petugas: json["petugas"],
        implementasi: json["implementasi"] == null
            ? []
            : List<Implementasi>.from(
                json["implementasi"]!.map((x) => Implementasi.fromJson(x))),
      );
}

class Implementasi {
  int? id;
  String? tindakan;
  String? jam;
  DateTime? rawJam;
  String? pegawai;

  Implementasi({
    this.id,
    this.tindakan,
    this.jam,
    this.rawJam,
    this.pegawai,
  });

  factory Implementasi.fromJson(Map<String, dynamic> json) => Implementasi(
        id: json["id"],
        tindakan: json["tindakan"],
        jam: json["jam"],
        rawJam: DateTime.parse(json["raw_jam"]),
        pegawai: json["pegawai"],
      );
}
