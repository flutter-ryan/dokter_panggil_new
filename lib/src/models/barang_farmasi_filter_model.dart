import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/master_farmasi_paginate_model.dart';

String barangFarmasiFilterModelToJson(BarangFarmasiFilterModel data) =>
    json.encode(data.toJson());

class BarangFarmasiFilterModel {
  BarangFarmasiFilterModel({
    required this.filter,
  });

  String filter;

  Map<String, dynamic> toJson() => {
        "filter": filter,
      };
}

ResponseBarangFarmasiFilterModel responseBarangFarmasiFilterModelFromJson(
        dynamic str) =>
    ResponseBarangFarmasiFilterModel.fromJson(str);

class ResponseBarangFarmasiFilterModel {
  ResponseBarangFarmasiFilterModel({
    this.barang,
    this.message,
  });

  List<BarangFarmasi>? barang;
  String? message;

  factory ResponseBarangFarmasiFilterModel.fromJson(
          Map<String, dynamic> json) =>
      ResponseBarangFarmasiFilterModel(
        barang: List<BarangFarmasi>.from(
            json["data"].map((x) => BarangFarmasi.fromJson(x))),
        message: json["message"],
      );
}
