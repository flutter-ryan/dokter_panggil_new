import 'dart:convert';

NewRiwayatKunjunganModel newRiwayatKunjunganModelFromJson(dynamic str) =>
    NewRiwayatKunjunganModel.fromJson(str);

class NewRiwayatKunjunganModel {
  List<NewRiwayatKunjungan>? data;
  String? nextPageUrl;
  String? prevPageUrl;

  NewRiwayatKunjunganModel({
    this.data,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory NewRiwayatKunjunganModel.fromJson(Map<String, dynamic> json) =>
      NewRiwayatKunjunganModel(
        data: json["data"] == null
            ? []
            : List<NewRiwayatKunjungan>.from(
                json["data"]!.map((x) => NewRiwayatKunjungan.fromJson(x))),
        nextPageUrl: json["nextPageUrl"],
        prevPageUrl: json["prevPageUrl"],
      );
}

class NewRiwayatKunjungan {
  int? id;
  String? nomorRegistrasi;
  String? norm;
  String? tanggalKunjungan;
  String? keluhan;
  String? dokter;
  String? perawat;
  String? namaPasien;
  int? status;

  NewRiwayatKunjungan({
    this.id,
    this.nomorRegistrasi,
    this.norm,
    this.tanggalKunjungan,
    this.keluhan,
    this.dokter,
    this.perawat,
    this.namaPasien,
    this.status,
  });

  factory NewRiwayatKunjungan.fromJson(Map<String, dynamic> json) =>
      NewRiwayatKunjungan(
        id: json["id"],
        nomorRegistrasi: json["nomor_registrasi"],
        norm: json["norm"],
        tanggalKunjungan: json["tanggal_kunjungan"],
        keluhan: json["keluhan"],
        dokter: json["dokter"],
        perawat: json["perawat"],
        namaPasien: json["nama_pasien"],
        status: json["status"],
      );
}

String newRiwayatKunjunganRequestModelToJson(
        NewRiwayatKunjunganRequestModel data) =>
    json.encode(data.toJson());

class NewRiwayatKunjunganRequestModel {
  String filter;

  NewRiwayatKunjunganRequestModel({
    required this.filter,
  });

  Map<String, dynamic> toJson() => {
        "filter": filter,
      };
}
