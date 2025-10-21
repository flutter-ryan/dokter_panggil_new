import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/stok_opname_model.dart';

StokOpnameBarangModel stokOpnameBarangModelFromJson(dynamic str) =>
    StokOpnameBarangModel.fromJson(str);

class StokOpnameBarangModel {
  List<BarangOpname>? data;
  String? message;

  StokOpnameBarangModel({
    this.data,
    this.message,
  });

  factory StokOpnameBarangModel.fromJson(Map<String, dynamic> json) =>
      StokOpnameBarangModel(
        data: json["data"] == null
            ? []
            : List<BarangOpname>.from(
                json["data"]!.map((x) => BarangOpname.fromJson(x))),
        message: json["message"],
      );
}

String stokOpnameBarangFilterModelToJson(StokOpnameBarangFilterModel data) =>
    json.encode(data.toJson());

class StokOpnameBarangFilterModel {
  String filter;

  StokOpnameBarangFilterModel({
    required this.filter,
  });

  Map<String, dynamic> toJson() => {
        "filter": filter,
      };
}
