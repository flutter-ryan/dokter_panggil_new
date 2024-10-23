import 'package:dokter_panggil/src/models/master_pegawai_fetch_model.dart';

DeletePegawaiModel deletePegawaiModelFromJson(dynamic str) =>
    DeletePegawaiModel.fromJson(str);

class DeletePegawaiModel {
  DeletePegawaiModel({
    this.data,
    this.message,
  });

  MasterPegawai? data;
  String? message;

  factory DeletePegawaiModel.fromJson(Map<String, dynamic> json) =>
      DeletePegawaiModel(
        data: MasterPegawai.fromJson(json["data"]),
        message: json["message"],
      );
}
