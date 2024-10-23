MasterMitraLabModel masterMitraLabModelFromJson(dynamic str) =>
    MasterMitraLabModel.fromJson(str);

class MasterMitraLabModel {
  MasterMitraLabModel({
    this.data,
    this.message,
  });

  List<MitraLab>? data;
  String? message;

  factory MasterMitraLabModel.fromJson(Map<String, dynamic> json) =>
      MasterMitraLabModel(
        data:
            List<MitraLab>.from(json["data"].map((x) => MitraLab.fromJson(x))),
        message: json["message"],
      );
}

class MitraLab {
  MitraLab({
    this.id,
    this.namaMitra,
    this.kode,
    this.jenis,
    this.status,
  });

  int? id;
  String? namaMitra;
  String? kode;
  String? jenis;
  int? status;

  factory MitraLab.fromJson(Map<String, dynamic> json) => MitraLab(
        id: json["id"],
        namaMitra: json["nama_mitra"],
        kode: json["kode"],
        jenis: json["jenis"],
        status: json["status"],
      );
}
