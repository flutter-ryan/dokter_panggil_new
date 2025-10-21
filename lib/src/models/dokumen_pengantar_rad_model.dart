import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

String dokumenPengantarRadModelToJson(DokumenPengantarRadModel data) =>
    json.encode(data.toJson());

class DokumenPengantarRadModel {
  int idKunjungan;
  String idPegawai;

  DokumenPengantarRadModel({
    required this.idKunjungan,
    required this.idPegawai,
  });

  Map<String, dynamic> toJson() => {
        "idKunjungan": idKunjungan,
        "idPegawai": idPegawai,
      };
}

ResponseDokumenPengantarRadModel responseDokumenPengantarRadModelFromJson(
        dynamic str) =>
    ResponseDokumenPengantarRadModel.fromJson(str);

class ResponseDokumenPengantarRadModel {
  DokumenPengantarRad? data;
  String? message;

  ResponseDokumenPengantarRadModel({
    this.data,
    this.message,
  });

  factory ResponseDokumenPengantarRadModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseDokumenPengantarRadModel(
        data: DokumenPengantarRad.fromJson(json["data"]),
        message: json["message"],
      );
}

class DokumenPengantarRad {
  int? id;
  int? kunjunganId;
  String? norm;
  String? linkDoc;
  Pasien? pasien;

  DokumenPengantarRad({
    this.id,
    this.kunjunganId,
    this.norm,
    this.linkDoc,
    this.pasien,
  });

  factory DokumenPengantarRad.fromJson(Map<String, dynamic> json) =>
      DokumenPengantarRad(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        norm: json["norm"],
        linkDoc: json["link_doc"],
        pasien: Pasien.fromJson(json["pasien"]),
      );
}

ResponseListTindakanRadPengantarModel
    responseListTindakanRadPengantarModelFromJson(dynamic str) =>
        ResponseListTindakanRadPengantarModel.fromJson(str);

class ResponseListTindakanRadPengantarModel {
  List<ListTindakanRadPengantar>? data;
  String? message;

  ResponseListTindakanRadPengantarModel({
    this.data,
    this.message,
  });

  factory ResponseListTindakanRadPengantarModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseListTindakanRadPengantarModel(
        data: List<ListTindakanRadPengantar>.from(
            json["data"].map((x) => ListTindakanRadPengantar.fromJson(x))),
        message: json["message"],
      );
}

class ListTindakanRadPengantar {
  int? id;
  String? tindakan;

  ListTindakanRadPengantar({
    this.id,
    this.tindakan,
  });

  factory ListTindakanRadPengantar.fromJson(Map<String, dynamic> json) =>
      ListTindakanRadPengantar(
        id: json["id"],
        tindakan: json["tindakan"],
      );
}
