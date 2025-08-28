MasterJenisIdentitasModel masterJenisIdentitasModelFromJson(dynamic str) =>
    MasterJenisIdentitasModel.fromJson(str);

class MasterJenisIdentitasModel {
  List<JenisIdentitas>? data;
  String? message;

  MasterJenisIdentitasModel({
    this.data,
    this.message,
  });

  factory MasterJenisIdentitasModel.fromJson(Map<String, dynamic> json) =>
      MasterJenisIdentitasModel(
        data: json["data"] == null
            ? []
            : List<JenisIdentitas>.from(
                json["data"]!.map((x) => JenisIdentitas.fromJson(x))),
        message: json["message"],
      );
}

class JenisIdentitas {
  int? id;
  String? jenis;

  JenisIdentitas({
    this.id,
    this.jenis,
  });

  factory JenisIdentitas.fromJson(Map<String, dynamic> json) => JenisIdentitas(
        id: json["id"],
        jenis: json["jenis"],
      );
}
