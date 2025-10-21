MasterTindakanModel masterTindakanModelFromJson(dynamic str) =>
    MasterTindakanModel.fromJson(str);

class MasterTindakanModel {
  MasterTindakanModel({
    this.data,
    this.message,
  });

  List<MasterTindakan>? data;
  String? message;

  factory MasterTindakanModel.fromJson(Map<String, dynamic> json) =>
      MasterTindakanModel(
        data: List<MasterTindakan>.from(
            json["data"].map((x) => MasterTindakan.fromJson(x))),
        message: json["message"],
      );
}

class MasterTindakan {
  MasterTindakan({
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

  factory MasterTindakan.fromJson(Map<String, dynamic> json) => MasterTindakan(
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
