MasterGroupJabatanModel masterGroupJabatanModelFromJson(dynamic str) =>
    MasterGroupJabatanModel.fromJson(str);

class MasterGroupJabatanModel {
  List<MasterGroupJabatan>? data;
  String? message;

  MasterGroupJabatanModel({
    this.data,
    this.message,
  });

  factory MasterGroupJabatanModel.fromJson(Map<String, dynamic> json) =>
      MasterGroupJabatanModel(
        data: List<MasterGroupJabatan>.from(
            json["data"].map((x) => MasterGroupJabatan.fromJson(x))),
        message: json["message"],
      );
}

class MasterGroupJabatan {
  int? id;
  String? groupJabatan;

  MasterGroupJabatan({
    this.id,
    this.groupJabatan,
  });

  factory MasterGroupJabatan.fromJson(Map<String, dynamic> json) =>
      MasterGroupJabatan(
        id: json["id"],
        groupJabatan: json["group_jabatan"],
      );
}
