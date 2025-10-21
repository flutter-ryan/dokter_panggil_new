import 'package:admin_dokter_panggil/src/models/dokumen_lab_save_model.dart';

DokumenLabModel dokumenLabModelFromJson(dynamic str) =>
    DokumenLabModel.fromJson(str);

class DokumenLabModel {
  List<DokumenLab>? data;
  String? message;

  DokumenLabModel({
    this.data,
    this.message,
  });

  factory DokumenLabModel.fromJson(Map<String, dynamic> json) =>
      DokumenLabModel(
        data: json["data"] == null
            ? []
            : List<DokumenLab>.from(
                json["data"]!.map((x) => DokumenLab.fromJson(x))),
        message: json["message"],
      );
}
