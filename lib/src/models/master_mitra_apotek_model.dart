MasterMitraApotekModel masterMitraApotekModelFromJson(dynamic str) =>
    MasterMitraApotekModel.fromJson(str);

class MasterMitraApotekModel {
  MasterMitraApotekModel({
    this.mitraApotek,
    this.message,
  });

  List<MitraApotek>? mitraApotek;
  String? message;

  factory MasterMitraApotekModel.fromJson(Map<String, dynamic> json) =>
      MasterMitraApotekModel(
        mitraApotek: List<MitraApotek>.from(
            json["data"].map((x) => MitraApotek.fromJson(x))),
        message: json["message"],
      );
}

class MitraApotek {
  MitraApotek({
    this.id,
    this.namaMitra,
    this.kode,
    this.jenis,
  });

  int? id;
  String? namaMitra;
  String? kode;
  String? jenis;

  factory MitraApotek.fromJson(Map<String, dynamic> json) => MitraApotek(
        id: json["id"],
        namaMitra: json["nama_mitra"],
        kode: json["kode"],
        jenis: json["jenis"],
      );
}
