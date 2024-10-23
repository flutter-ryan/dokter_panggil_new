import 'dart:convert';

import 'package:dokter_panggil/src/models/stok_opname_model.dart';

StokOpnameBarangSaveModel stokOpnameBarangSaveModelFromJson(dynamic str) =>
    StokOpnameBarangSaveModel.fromJson(str);

class StokOpnameBarangSaveModel {
  BarangOpname? data;
  String? message;

  StokOpnameBarangSaveModel({
    this.data,
    this.message,
  });

  factory StokOpnameBarangSaveModel.fromJson(Map<String, dynamic> json) =>
      StokOpnameBarangSaveModel(
        data: BarangOpname.fromJson(json["data"]),
        message: json["message"],
      );
}

String kirimStokOpnameBarangSaveModelToJson(
        KirimStokOpnameBarangSaveModel data) =>
    json.encode(data.toJson());

class KirimStokOpnameBarangSaveModel {
  int stok;

  KirimStokOpnameBarangSaveModel({
    required this.stok,
  });

  Map<String, dynamic> toJson() => {
        "stok": stok,
      };
}
