TindakanEditModel tindakanEditModelFromJson(dynamic str) =>
    TindakanEditModel.fromJson(str);

class TindakanEditModel {
  TindakanEditModel({
    this.tindakan,
    this.message,
  });

  Tindakan? tindakan;
  String? message;

  factory TindakanEditModel.fromJson(Map<String, dynamic> json) =>
      TindakanEditModel(
        tindakan: Tindakan.fromJson(json["data"]),
        message: json["message"],
      );
}

class Tindakan {
  Tindakan({
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
    this.kategoriId,
    this.namaKategori,
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
  int? kategoriId;
  String? namaKategori;

  factory Tindakan.fromJson(Map<String, dynamic> json) => Tindakan(
        id: json["id"],
        namaTindakan: json["nama_tindakan"],
        tarif: json["tarif"],
        jasaDokter: json["jasa_dokter"],
        jasaDokterPanggil: json["jasa_dokter_panggil"],
        bayarLangsung: json["bayar_langsung"],
        transportasi: json["transportasi"],
        gojek: json["gojek"],
        status: json["status"],
        groupId: json["group_id"],
        groupJabatan: json["group_jabatan"],
        kategoriId: json["kategori_id"],
        namaKategori: json["nama_kategori"],
      );
}
