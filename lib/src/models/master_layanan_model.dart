MasterLayananModel masterLayananModelFromJson(dynamic str) =>
    MasterLayananModel.fromJson(str);

class MasterLayananModel {
  List<MasterLayanan> data;
  String message;

  MasterLayananModel({
    required this.data,
    required this.message,
  });

  factory MasterLayananModel.fromJson(Map<String, dynamic> json) =>
      MasterLayananModel(
        data: List<MasterLayanan>.from(
            json["data"].map((x) => MasterLayanan.fromJson(x))),
        message: json["message"],
      );
}

class MasterLayanan {
  int? id;
  String? namaLayanan;
  int? tindakanIdDefault;
  int? status;
  int? isBayarLangsung;
  int? isDokter;
  int? isPerawat;
  TindakanLayanan? tindakanLayanan;

  MasterLayanan({
    this.id,
    this.namaLayanan,
    this.tindakanIdDefault,
    this.status,
    this.isBayarLangsung,
    this.isDokter,
    this.isPerawat,
    this.tindakanLayanan,
  });

  factory MasterLayanan.fromJson(Map<String, dynamic> json) => MasterLayanan(
        id: json["id"],
        namaLayanan: json["nama_layanan"],
        tindakanIdDefault: json["tindakan_id_default"],
        isBayarLangsung: json["is_bayar_langsung"],
        status: json["status"],
        isDokter: json["is_dokter"],
        isPerawat: json['is_perawat'],
        tindakanLayanan: json["tindakan_layanan"] == null
            ? null
            : TindakanLayanan.fromJson(json["tindakan_layanan"]),
      );
}

class TindakanLayanan {
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

  TindakanLayanan({
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

  factory TindakanLayanan.fromJson(Map<String, dynamic> json) =>
      TindakanLayanan(
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
