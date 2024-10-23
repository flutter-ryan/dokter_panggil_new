import 'dart:convert';

String resumeSoapModelToJson(ResumeSoapModel data) =>
    json.encode(data.toJson());

class ResumeSoapModel {
  int idKunjungan;
  int idPetugas;

  ResumeSoapModel({
    required this.idKunjungan,
    required this.idPetugas,
  });

  Map<String, dynamic> toJson() => {
        "idKunjungan": idKunjungan,
        "idPetugas": idPetugas,
      };
}

ResponseResumeSoapModel responseResumeSoapModelFromJson(dynamic str) =>
    ResponseResumeSoapModel.fromJson(str);

class ResponseResumeSoapModel {
  List<ResumeSoap>? data;
  String? message;

  ResponseResumeSoapModel({
    this.data,
    this.message,
  });

  factory ResponseResumeSoapModel.fromJson(Map<String, dynamic> json) =>
      ResponseResumeSoapModel(
        data: List<ResumeSoap>.from(
            json["data"].map((x) => ResumeSoap.fromJson(x))),
        message: json["message"],
      );
}

class ResumeSoap {
  int? id;
  String? objective;
  String? subjective;
  String? assesment;
  String? planning;
  String? instruksi;
  String? tanggal;

  ResumeSoap({
    this.id,
    this.objective,
    this.subjective,
    this.assesment,
    this.planning,
    this.instruksi,
    this.tanggal,
  });

  factory ResumeSoap.fromJson(Map<String, dynamic> json) => ResumeSoap(
        id: json["id"],
        objective: json["objective"],
        subjective: json["subjective"],
        assesment: json["assesment"],
        planning: json["planning"],
        instruksi: json["instruksi"],
        tanggal: json["tanggal"],
      );
}
