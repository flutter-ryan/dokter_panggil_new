import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/bhp_kategori_model.dart';

String bhpKategoriSaveModelToJson(BhpKategoriSaveModel data) =>
    json.encode(data.toJson());

class BhpKategoriSaveModel {
  BhpKategoriSaveModel({
    required this.kategori,
  });

  String kategori;

  Map<String, dynamic> toJson() => {
        "kategori": kategori,
      };
}

ResponseBhpKategoriSaveModel responseBhpKategoriSaveModelFromJson(
        dynamic str) =>
    ResponseBhpKategoriSaveModel.fromJson(str);

class ResponseBhpKategoriSaveModel {
  ResponseBhpKategoriSaveModel({
    this.data,
    this.message,
  });

  BhpKategori? data;
  String? message;

  factory ResponseBhpKategoriSaveModel.fromJson(Map<String, dynamic> json) =>
      ResponseBhpKategoriSaveModel(
        data: BhpKategori.fromJson(json["data"]),
        message: json["message"],
      );
}
