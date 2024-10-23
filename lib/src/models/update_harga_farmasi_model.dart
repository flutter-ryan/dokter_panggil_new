import 'dart:convert';

import 'package:dokter_panggil/src/models/master_farmasi_paginate_model.dart';

String updateHargaFarmasiModelToJson(UpdateHargaFarmasiModel data) =>
    json.encode(data.toJson());

class UpdateHargaFarmasiModel {
  UpdateHargaFarmasiModel({
    required this.hargaModal,
  });

  int hargaModal;

  Map<String, dynamic> toJson() => {
        "hargaModal": hargaModal,
      };
}

ResponseUpdateHargaFarmasiModel responseUpdateHargaFarmasiModelFromJson(
        dynamic str) =>
    ResponseUpdateHargaFarmasiModel.fromJson(str);

class ResponseUpdateHargaFarmasiModel {
  ResponseUpdateHargaFarmasiModel({
    this.data,
    this.message,
  });

  BarangFarmasi? data;
  String? message;

  factory ResponseUpdateHargaFarmasiModel.fromJson(Map<String, dynamic> json) =>
      ResponseUpdateHargaFarmasiModel(
        data: BarangFarmasi.fromJson(json["data"]),
        message: json["message"],
      );
}
