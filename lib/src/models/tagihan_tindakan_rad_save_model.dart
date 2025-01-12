import 'dart:convert';

import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';

TagihanTindakanRadSaveModel tagihanTindakanRadSaveModelFromJson(dynamic str) =>
    TagihanTindakanRadSaveModel.fromJson(str);

class TagihanTindakanRadSaveModel {
  DetailKunjungan? data;
  String? message;

  TagihanTindakanRadSaveModel({
    this.data,
    this.message,
  });

  factory TagihanTindakanRadSaveModel.fromJson(Map<String, dynamic> json) =>
      TagihanTindakanRadSaveModel(
        data: json["data"] == null
            ? null
            : DetailKunjungan.fromJson(json["data"]),
        message: json["message"],
      );
}

String tagihanTindakanRadRequestModelToJson(
        TagihanTindakanRadRequestModel data) =>
    json.encode(data.toJson());

class TagihanTindakanRadRequestModel {
  List<TindakanRadRequest> tindakanRad;

  TagihanTindakanRadRequestModel({
    required this.tindakanRad,
  });

  Map<String, dynamic> toJson() => {
        "tindakanRad": List<dynamic>.from(tindakanRad.map((x) => x.toJson())),
      };
}

class TindakanRadRequest {
  int id;
  int hargaModal;
  int tarifAplikasi;

  TindakanRadRequest({
    required this.id,
    required this.hargaModal,
    required this.tarifAplikasi,
  });

  factory TindakanRadRequest.fromJson(Map<String, dynamic> json) =>
      TindakanRadRequest(
        id: json["id"],
        hargaModal: json["hargaModal"],
        tarifAplikasi: json["tarifAplikasi"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "hargaModal": hargaModal,
        "tarifAplikasi": tarifAplikasi,
      };
}
