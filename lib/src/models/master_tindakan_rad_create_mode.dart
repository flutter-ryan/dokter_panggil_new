MasterTindakanRadCreateModel masterTindakanRadCreateModelFromJson(
        dynamic str) =>
    MasterTindakanRadCreateModel.fromJson(str);

class MasterTindakanRadCreateModel {
  MasterTindakanRadCreateModel({
    this.data,
    this.message,
  });

  List<MasterTindakanRad>? data;
  String? message;

  factory MasterTindakanRadCreateModel.fromJson(Map<String, dynamic> json) =>
      MasterTindakanRadCreateModel(
        data: List<MasterTindakanRad>.from(
            json["data"].map((x) => MasterTindakanRad.fromJson(x))),
        message: json["message"],
      );
}

class MasterTindakanRad {
  MasterTindakanRad({
    this.id,
    this.namaTindakan,
    this.hargaJual,
    this.hargaModal,
    this.tarifAplikasi,
  });

  int? id;
  String? namaTindakan;
  int? hargaJual;
  int? hargaModal;
  int? tarifAplikasi;

  factory MasterTindakanRad.fromJson(Map<String, dynamic> json) =>
      MasterTindakanRad(
        id: json["id"],
        namaTindakan: json["nama_tindakan"],
        hargaJual: json["harga_jual"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
      );
}
