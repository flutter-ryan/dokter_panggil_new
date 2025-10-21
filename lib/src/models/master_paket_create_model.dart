import 'dart:convert';

String masterPaketCreateModelToJson(MasterPaketCreateModel data) =>
    json.encode(data.toJson());

class MasterPaketCreateModel {
  MasterPaketCreateModel({
    required this.filter,
  });

  String filter;

  Map<String, dynamic> toJson() => {
        "filter": filter,
      };
}

ResponseMasterPaketCreateModel responseMasterPaketCreateModelFromJson(
        dynamic str) =>
    ResponseMasterPaketCreateModel.fromJson(str);

class ResponseMasterPaketCreateModel {
  ResponseMasterPaketCreateModel({
    this.data,
    this.message,
  });

  List<MasterPaket>? data;
  String? message;

  factory ResponseMasterPaketCreateModel.fromJson(Map<String, dynamic> json) =>
      ResponseMasterPaketCreateModel(
        data: List<MasterPaket>.from(
            json["data"].map((x) => MasterPaket.fromJson(x))),
        message: json["message"],
      );
}

class MasterPaket {
  MasterPaket({
    this.id,
    this.namaPaket,
    this.jenisHarga,
    this.persen,
    this.harga,
    this.tindakan,
    this.drugs,
    this.consumes,
    this.farmasi,
    this.lab,
    this.rad,
  });

  int? id;
  String? namaPaket;
  String? jenisHarga;
  int? persen;
  int? harga;
  List<PaketTindakan>? tindakan;
  List<PaketDrugs>? drugs;
  List<PaketConsumes>? consumes;
  List<PaketFarmasi>? farmasi;
  List<PaketLab>? lab;
  List<PaketRad>? rad;

  factory MasterPaket.fromJson(Map<String, dynamic> json) => MasterPaket(
        id: json["id"],
        namaPaket: json["nama_paket"],
        jenisHarga: json["jenis_harga"],
        persen: json["persen"],
        harga: json["harga"],
        tindakan: List<PaketTindakan>.from(
            json["tindakan"].map((x) => PaketTindakan.fromJson(x))),
        drugs: List<PaketDrugs>.from(
            json["drugs"].map((x) => PaketDrugs.fromJson(x))),
        consumes: List<PaketConsumes>.from(
            json["consumes"].map((x) => PaketConsumes.fromJson(x))),
        farmasi: List<PaketFarmasi>.from(
            json["farmasi"].map((x) => PaketFarmasi.fromJson(x))),
        lab: List<PaketLab>.from(json["lab"].map((x) => PaketLab.fromJson(x))),
        rad: List<PaketRad>.from(json["rad"].map((x) => PaketRad.fromJson(x))),
      );
}

class PaketTindakan {
  PaketTindakan({
    this.id,
    this.namaTindakan,
    this.tarif,
    this.jasaDokter,
    this.jasaDokterPanggil,
    this.bayarLangsung,
    this.transportasi,
    this.gojek,
    this.qty,
    this.isDokter,
  });

  int? id;
  String? namaTindakan;
  int? tarif;
  int? jasaDokter;
  int? jasaDokterPanggil;
  int? bayarLangsung;
  int? transportasi;
  int? gojek;
  int? qty;
  int? isDokter;

  factory PaketTindakan.fromJson(Map<String, dynamic> json) => PaketTindakan(
        id: json["id"],
        namaTindakan: json["nama_tindakan"],
        tarif: json["tarif"],
        jasaDokter: json["jasa_dokter"],
        jasaDokterPanggil: json["jasa_admin_dokter_panggil"],
        bayarLangsung: json["bayar_langsung"],
        transportasi: json["transportasi"],
        gojek: json["gojek"],
        qty: json["qty"],
        isDokter: json["is_dokter"],
      );
}

class PaketDrugs {
  PaketDrugs({
    this.id,
    this.namaBarang,
    this.minStok,
    this.hargaJual,
    this.hargaModal,
    this.tarifAplikasi,
    this.categoryId,
    this.qty,
    this.aturanPakai,
    this.catatan,
  });

  int? id;
  String? namaBarang;
  int? minStok;
  int? hargaJual;
  int? hargaModal;
  int? tarifAplikasi;
  int? categoryId;
  int? qty;
  String? aturanPakai;
  String? catatan;

  factory PaketDrugs.fromJson(Map<String, dynamic> json) => PaketDrugs(
        id: json["id"],
        namaBarang: json["nama_barang"],
        minStok: json["min_stok"],
        hargaJual: json["harga_jual"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        categoryId: json["category_id"],
        qty: json["qty"],
        aturanPakai: json["aturan_pakai"],
        catatan: json["catatan"],
      );
}

class PaketConsumes {
  PaketConsumes({
    this.id,
    this.namaBarang,
    this.minStok,
    this.hargaJual,
    this.hargaModal,
    this.tarifAplikasi,
    this.categoryId,
    this.qty,
  });

  int? id;
  String? namaBarang;
  int? minStok;
  int? hargaJual;
  int? hargaModal;
  int? tarifAplikasi;
  int? categoryId;
  int? qty;

  factory PaketConsumes.fromJson(Map<String, dynamic> json) => PaketConsumes(
        id: json["id"],
        namaBarang: json["nama_barang"],
        minStok: json["min_stok"],
        hargaJual: json["harga_jual"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        categoryId: json["category_id"],
        qty: json["qty"],
      );
}

class PaketFarmasi {
  PaketFarmasi({
    this.id,
    this.namaBarang,
    this.satuan,
    this.hargaJual,
    this.hargaModal,
    this.tarifAplikasi,
    this.qty,
  });

  int? id;
  String? namaBarang;
  String? satuan;
  int? hargaJual;
  int? hargaModal;
  int? tarifAplikasi;
  int? qty;

  factory PaketFarmasi.fromJson(Map<String, dynamic> json) => PaketFarmasi(
        id: json["id"],
        namaBarang: json["nama_barang"],
        satuan: json["satuan"],
        hargaJual: json["harga_jual"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
        qty: json["qty"],
      );
}

class PaketLab {
  PaketLab({
    this.id,
    this.namaTindakanLab,
    this.hargaJual,
    this.hargaModal,
    this.tarifAplikasi,
  });

  int? id;
  String? namaTindakanLab;
  int? hargaJual;
  int? hargaModal;
  int? tarifAplikasi;

  factory PaketLab.fromJson(Map<String, dynamic> json) => PaketLab(
        id: json["id"],
        namaTindakanLab: json["nama_tindakan_lab"],
        hargaJual: json["harga_jual"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
      );
}

class PaketRad {
  PaketRad({
    this.id,
    this.namaTindakanRad,
    this.hargaJual,
    this.hargaModal,
    this.tarifAplikasi,
  });

  int? id;
  String? namaTindakanRad;
  int? hargaJual;
  int? hargaModal;
  int? tarifAplikasi;

  factory PaketRad.fromJson(Map<String, dynamic> json) => PaketRad(
        id: json["id"],
        namaTindakanRad: json["nama_tindakan"],
        hargaJual: json["harga_jual"],
        hargaModal: json["harga_modal"],
        tarifAplikasi: json["tarif_aplikasi"],
      );
}
