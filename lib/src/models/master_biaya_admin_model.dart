MasterBiayaAdminModel masterBiayaAdminModelFromJson(dynamic str) =>
    MasterBiayaAdminModel.fromJson(str);

class MasterBiayaAdminModel {
  MasterBiayaAdminModel({
    this.data,
    this.message,
  });

  List<MasterBiayaAdmin>? data;
  String? message;

  factory MasterBiayaAdminModel.fromJson(Map<String, dynamic> json) =>
      MasterBiayaAdminModel(
        data: List<MasterBiayaAdmin>.from(
            json["data"].map((x) => MasterBiayaAdmin.fromJson(x))),
        message: json["message"],
      );
}

class MasterBiayaAdmin {
  MasterBiayaAdmin({
    this.id,
    this.deskripsi,
    this.nilai,
    this.persen,
  });

  int? id;
  String? deskripsi;
  int? nilai;
  int? persen;

  factory MasterBiayaAdmin.fromJson(Map<String, dynamic> json) =>
      MasterBiayaAdmin(
        id: json["id"],
        deskripsi: json["deskripsi"],
        nilai: json["nilai"],
        persen: json["persen"],
      );
}
