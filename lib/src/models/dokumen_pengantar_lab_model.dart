import 'dart:convert';
import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String dokumenPengantarLabModelToJson(DokumenPengantarLabModel data) =>
    json.encode(data.toJson());

class DokumenPengantarLabModel {
  int idKunjungan;
  String idPegawai;

  DokumenPengantarLabModel({
    required this.idKunjungan,
    required this.idPegawai,
  });

  Map<String, dynamic> toJson() => {
        "idKunjungan": idKunjungan,
        "idPegawai": idPegawai,
      };
}

ResponseDokumenPengantarLabModel responseDokumenPengantarLabModelFromJson(
        dynamic str) =>
    ResponseDokumenPengantarLabModel.fromJson(str);

class ResponseDokumenPengantarLabModel {
  DokumenPengantarLab? data;
  String? message;

  ResponseDokumenPengantarLabModel({
    this.data,
    this.message,
  });

  factory ResponseDokumenPengantarLabModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseDokumenPengantarLabModel(
        data: DokumenPengantarLab.fromJson(json["data"]),
        message: json["message"],
      );
}

class DokumenPengantarLab {
  int? id;
  int? kunjunganId;
  String? norm;
  String? linkDoc;
  Pasien? pasien;

  DokumenPengantarLab({
    this.id,
    this.kunjunganId,
    this.norm,
    this.linkDoc,
    this.pasien,
  });

  factory DokumenPengantarLab.fromJson(Map<String, dynamic> json) =>
      DokumenPengantarLab(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        norm: json["norm"],
        linkDoc: json["link_doc"],
        pasien: Pasien.fromJson(json["pasien"]),
      );
}

ResponseListTindakanLabPengantarModel
    responseListTindakanLabPengantarModelFromJson(dynamic str) =>
        ResponseListTindakanLabPengantarModel.fromJson(str);

class ResponseListTindakanLabPengantarModel {
  List<ListTindakanLabPengantar>? data;
  String? message;

  ResponseListTindakanLabPengantarModel({
    this.data,
    this.message,
  });

  factory ResponseListTindakanLabPengantarModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseListTindakanLabPengantarModel(
        data: List<ListTindakanLabPengantar>.from(
          json["data"].map((x) => ListTindakanLabPengantar.fromJson(x)),
        ),
        message: json["message"],
      );
}

class ListTindakanLabPengantar {
  int? id;
  String? tindakan;

  ListTindakanLabPengantar({
    this.id,
    this.tindakan,
  });

  factory ListTindakanLabPengantar.fromJson(Map<String, dynamic> json) =>
      ListTindakanLabPengantar(
        id: json["id"],
        tindakan: json["tindakan"],
      );
}
