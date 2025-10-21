import 'package:admin_dokter_panggil/src/models/dokumen_pengantar_lab_model.dart';

MrDokumenPengantarLabModel mrDokumenPengantarLabModelFromJson(dynamic str) =>
    MrDokumenPengantarLabModel.fromJson(str);

class MrDokumenPengantarLabModel {
  DokumenPengantarLab? data;
  String? message;

  MrDokumenPengantarLabModel({
    this.data,
    this.message,
  });

  factory MrDokumenPengantarLabModel.fromJson(Map<String, dynamic> json) =>
      MrDokumenPengantarLabModel(
        data: json["data"] == null
            ? null
            : DokumenPengantarLab.fromJson(json["data"]),
        message: json["message"],
      );
}
