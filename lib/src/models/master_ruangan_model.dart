MasterRuanganModel masterRuanganModelFromJson(dynamic str) =>
    MasterRuanganModel.fromJson(str);

class MasterRuanganModel {
  List<MasterRuangan>? data;
  String? message;

  MasterRuanganModel({
    this.data,
    this.message,
  });

  factory MasterRuanganModel.fromJson(Map<String, dynamic> json) =>
      MasterRuanganModel(
        data: json["data"] == null
            ? []
            : List<MasterRuangan>.from(
                json["data"]!.map((x) => MasterRuangan.fromJson(x))),
        message: json["message"],
      );
}

class MasterRuangan {
  int? id;
  String? namaRuangan;
  String? deskripsi;
  String? code;

  MasterRuangan({
    this.id,
    this.namaRuangan,
    this.deskripsi,
    this.code,
  });

  factory MasterRuangan.fromJson(Map<String, dynamic> json) => MasterRuangan(
        id: json["id"],
        namaRuangan: json["nama_ruangan"],
        deskripsi: json["deskripsi"],
        code: json["code"],
      );
}
