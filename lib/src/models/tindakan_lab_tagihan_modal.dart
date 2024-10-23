TindakanLabTagihanModel tindakanLabTagihanModelFromJson(dynamic str) =>
    TindakanLabTagihanModel.fromJson(str);

class TindakanLabTagihanModel {
  List<MitraTindakanLab>? data;
  String? message;

  TindakanLabTagihanModel({
    this.data,
    this.message,
  });

  factory TindakanLabTagihanModel.fromJson(Map<String, dynamic> json) =>
      TindakanLabTagihanModel(
        data: List<MitraTindakanLab>.from(
            json["data"].map((x) => MitraTindakanLab.fromJson(x))),
        message: json["message"],
      );
}

class MitraTindakanLab {
  int? id;
  String? kode;
  String? jenis;
  String? namaMitra;
  List<TindakanLabTagihan>? tindakanLab;

  MitraTindakanLab({
    this.id,
    this.kode,
    this.jenis,
    this.namaMitra,
    this.tindakanLab,
  });

  factory MitraTindakanLab.fromJson(Map<String, dynamic> json) =>
      MitraTindakanLab(
        id: json["id"],
        kode: json["kode"],
        jenis: json["jenis"],
        namaMitra: json["nama_mitra"],
        tindakanLab: List<TindakanLabTagihan>.from(
          json["tindakan_lab"].map((x) => TindakanLabTagihan.fromJson(x)),
        ),
      );
}

class TindakanLabTagihan {
  int? id;
  String? namaTindakanLab;
  int? hargaJual;
  int? hargaModal;
  int? tarifAplikasi;

  TindakanLabTagihan({
    this.id,
    this.namaTindakanLab,
    this.hargaJual,
    this.hargaModal,
    this.tarifAplikasi,
  });

  factory TindakanLabTagihan.fromJson(Map<String, dynamic> json) =>
      TindakanLabTagihan(
        id: json["id"],
        namaTindakanLab: json["nama_tindakan_lab"],
        hargaJual: json["harga_jual"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
      );
}
