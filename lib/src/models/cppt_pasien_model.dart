import 'dart:convert';

CpptPasienModel cpptPasienModelFromJson(dynamic str) =>
    CpptPasienModel.fromJson(str);

class CpptPasienModel {
  List<CpptPasien>? data;
  String? message;

  CpptPasienModel({
    this.data,
    this.message,
  });

  factory CpptPasienModel.fromJson(Map<String, dynamic> json) =>
      CpptPasienModel(
        data: json["data"] == null
            ? []
            : List<CpptPasien>.from(
                json["data"]!.map((x) => CpptPasien.fromJson(x))),
        message: json["message"],
      );
}

class CpptPasien {
  int? id;
  String? objective;
  String? subjective;
  String? assesment;
  String? planning;
  String? instruksi;
  String? tanggal;

  CpptPasien({
    this.id,
    this.objective,
    this.subjective,
    this.assesment,
    this.planning,
    this.instruksi,
    this.tanggal,
  });

  factory CpptPasien.fromJson(Map<String, dynamic> json) => CpptPasien(
        id: json["id"],
        objective: json["objective"],
        subjective: json["subjective"],
        assesment: json["assesment"],
        planning: json["planning"],
        instruksi: json["instruksi"],
        tanggal: json["tanggal"],
      );
}

String cpptPasienRequestModelToJson(CpptPasienRequestModel data) =>
    json.encode(data.toJson());

class CpptPasienRequestModel {
  int idKunjungan;
  int idPetugas;

  CpptPasienRequestModel({
    required this.idKunjungan,
    required this.idPetugas,
  });

  Map<String, dynamic> toJson() => {
        "idKunjungan": idKunjungan,
        "idPetugas": idPetugas,
      };
}
