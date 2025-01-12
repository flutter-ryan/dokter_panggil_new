MasterKategoriTindakanModel masterKategoriTindakanModelFromJson(dynamic str) =>
    MasterKategoriTindakanModel.fromJson(str);

class MasterKategoriTindakanModel {
  List<MasterKategoriTindakan>? data;
  String? message;

  MasterKategoriTindakanModel({
    this.data,
    this.message,
  });

  factory MasterKategoriTindakanModel.fromJson(Map<String, dynamic> json) =>
      MasterKategoriTindakanModel(
        data: json["data"] == null
            ? []
            : List<MasterKategoriTindakan>.from(
                json["data"]!.map((x) => MasterKategoriTindakan.fromJson(x))),
        message: json["message"],
      );
}

class MasterKategoriTindakan {
  int? id;
  String? namaKategori;

  MasterKategoriTindakan({
    this.id,
    this.namaKategori,
  });

  factory MasterKategoriTindakan.fromJson(Map<String, dynamic> json) =>
      MasterKategoriTindakan(
        id: json["id"],
        namaKategori: json["nama_kategori"],
      );
}
