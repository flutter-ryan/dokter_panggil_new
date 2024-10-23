import 'package:dokter_panggil/src/models/master_pegawai_fetch_model.dart';

PegawaiEditModel pegawaiEditModelFromJson(dynamic str) =>
    PegawaiEditModel.fromJson(str);

class PegawaiEditModel {
  PegawaiEditModel({
    this.pegawai,
    this.message,
  });

  MasterPegawai? pegawai;
  String? message;

  factory PegawaiEditModel.fromJson(Map<String, dynamic> json) =>
      PegawaiEditModel(
        pegawai: MasterPegawai.fromJson(json["data"]),
        message: json["message"],
      );
}
