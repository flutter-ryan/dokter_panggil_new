import 'dart:convert';

import 'package:admin_dokter_panggil/src/models/stok_opname_model.dart';

StokOpnameSaveModel stokOpnameSaveModelFromJson(dynamic str) =>
    StokOpnameSaveModel.fromJson(str);

class StokOpnameSaveModel {
  StokOpname? data;
  String? message;

  StokOpnameSaveModel({
    this.data,
    this.message,
  });

  factory StokOpnameSaveModel.fromJson(Map<String, dynamic> json) =>
      StokOpnameSaveModel(
        data: StokOpname.fromJson(json["data"]),
        message: json["message"],
      );
}

String kirimStokOpnameToJson(KirimStokOpname data) =>
    json.encode(data.toJson());

class KirimStokOpname {
  String from;
  String to;

  KirimStokOpname({
    required this.from,
    required this.to,
  });

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
      };
}
