TindakanCreateModel tindakanCreateModelFromJson(dynamic str) =>
    TindakanCreateModel.fromJson(str);

class TindakanCreateModel {
  TindakanCreateModel({
    this.tindakan,
    this.message,
  });

  List<TindakanCreate>? tindakan;
  String? message;

  factory TindakanCreateModel.fromJson(Map<String, dynamic> json) =>
      TindakanCreateModel(
        tindakan: List<TindakanCreate>.from(
            json["data"].map((x) => TindakanCreate.fromJson(x))),
        message: json["message"],
      );
}

class TindakanCreate {
  TindakanCreate({
    this.id,
    this.namaTindakan,
    this.tarif,
    this.jasaDokter,
    this.jasaDokterPanggil,
    this.bayarLangsung,
    this.transportasi,
    this.gojek,
    this.status,
    this.groupId,
    this.groupJabatan,
  });

  int? id;
  String? namaTindakan;
  int? tarif;
  int? jasaDokter;
  int? jasaDokterPanggil;
  int? bayarLangsung;
  int? transportasi;
  int? gojek;
  int? status;
  int? groupId;
  String? groupJabatan;

  factory TindakanCreate.fromJson(Map<String, dynamic> json) => TindakanCreate(
        id: json["id"],
        namaTindakan: json["nama_tindakan"],
        tarif: json["tarif"],
        jasaDokter: json["jasa_dokter"],
        jasaDokterPanggil: json["jasa_admin_dokter_panggil"],
        bayarLangsung: json["bayar_langsung"],
        transportasi: json["transportasi"],
        gojek: json["gojek"],
        status: json["status"],
        groupId: json["group_id"],
        groupJabatan: json["group_jabatan"],
      );
}
