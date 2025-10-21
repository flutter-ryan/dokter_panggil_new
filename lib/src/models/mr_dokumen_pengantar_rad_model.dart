import 'package:admin_dokter_panggil/src/models/dokumen_pengantar_rad_model.dart';

MrDokumenPengantarRadModel mrDokumenPengantarRadModelFromJson(dynamic str) =>
    MrDokumenPengantarRadModel.fromJson(str);

class MrDokumenPengantarRadModel {
  DokumenPengantarRad? data;
  String? message;

  MrDokumenPengantarRadModel({
    this.data,
    this.message,
  });

  factory MrDokumenPengantarRadModel.fromJson(Map<String, dynamic> json) =>
      MrDokumenPengantarRadModel(
        data: DokumenPengantarRad.fromJson(json["data"]),
        message: json["message"],
      );
}
