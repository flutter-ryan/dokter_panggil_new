import 'dart:convert';

MrPencarianBarangFarmasiModel mrPencarianBarangFarmasiModelFromJson(
        dynamic str) =>
    MrPencarianBarangFarmasiModel.fromJson(str);

class MrPencarianBarangFarmasiModel {
  List<MrBarangFarmasi>? data;
  int? currentPage;
  int? totalPage;
  String? message;
  int? total;

  MrPencarianBarangFarmasiModel({
    this.data,
    this.currentPage,
    this.totalPage,
    this.message,
    this.total,
  });

  factory MrPencarianBarangFarmasiModel.fromJson(Map<String, dynamic> json) =>
      MrPencarianBarangFarmasiModel(
        data: json["data"] == null
            ? []
            : List<MrBarangFarmasi>.from(
                json["data"]!.map((x) => MrBarangFarmasi.fromJson(x))),
        currentPage: json["current_page"],
        totalPage: json["totalPage"],
        message: json["message"],
        total: json["total"],
      );
}

class MrBarangFarmasi {
  int? id;
  String? namaBarang;
  String? satuan;
  int? hargaJual;
  int? hargaModal;
  int? tarifAplikasi;
  int? status;
  MrBarangFarmasiMitra? mitra;

  MrBarangFarmasi({
    this.id,
    this.namaBarang,
    this.satuan,
    this.hargaJual,
    this.hargaModal,
    this.tarifAplikasi,
    this.status,
    this.mitra,
  });

  factory MrBarangFarmasi.fromJson(Map<String, dynamic> json) =>
      MrBarangFarmasi(
        id: json["id"],
        namaBarang: json["nama_barang"],
        satuan: json["satuan"],
        hargaJual: json["harga_jual"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        status: json["status"],
        mitra: json["mitra"] == null
            ? null
            : MrBarangFarmasiMitra.fromJson(json["mitra"]),
      );
}

class MrBarangFarmasiMitra {
  int? id;
  String? namaMitra;
  MrBarangFarmasiMitra({
    this.id,
    this.namaMitra,
  });

  factory MrBarangFarmasiMitra.fromJson(Map<String, dynamic> json) =>
      MrBarangFarmasiMitra(
        id: json["id"],
        namaMitra: json["nama_mitra"],
      );
}

String mrPencarianBarangFarmasiRequestModelToJson(
        MrPencarianBarangFarmasiRequestModel data) =>
    json.encode(data.toJson());

class MrPencarianBarangFarmasiRequestModel {
  String filter;

  MrPencarianBarangFarmasiRequestModel({
    required this.filter,
  });

  Map<String, dynamic> toJson() => {
        "filter": filter,
      };
}
