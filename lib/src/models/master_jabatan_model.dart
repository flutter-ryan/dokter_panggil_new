import 'package:dokter_panggil/src/models/master_group_jabatan_model.dart';

MasterJabatanModel masterJabatanModelFromJson(dynamic str) =>
    MasterJabatanModel.fromJson(str);

class MasterJabatanModel {
  MasterJabatanModel({
    this.data,
    this.message,
  });

  List<Jabatan>? data;
  String? message;

  factory MasterJabatanModel.fromJson(Map<String, dynamic> json) =>
      MasterJabatanModel(
        data: List<Jabatan>.from(json["data"].map((x) => Jabatan.fromJson(x))),
        message: json["message"],
      );
}

class Jabatan {
  Jabatan({
    this.id,
    this.namaJabatan,
    this.group,
    this.status,
  });

  int? id;
  String? namaJabatan;
  MasterGroupJabatan? group;
  int? status;

  factory Jabatan.fromJson(Map<String, dynamic> json) => Jabatan(
        id: json["id"],
        namaJabatan: json["nama_jabatan"],
        group: MasterGroupJabatan.fromJson(json["group"]),
        status: json["status"],
      );
}
