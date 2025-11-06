MrKunjunganConsentTindakanModel mrKunjunganConsentTindakanModelFromJson(
        dynamic str) =>
    MrKunjunganConsentTindakanModel.fromJson(str);

class MrKunjunganConsentTindakanModel {
  List<DataKunjunganConsentTindakan>? data;
  String? message;

  MrKunjunganConsentTindakanModel({
    this.data,
    this.message,
  });

  factory MrKunjunganConsentTindakanModel.fromJson(Map<String, dynamic> json) =>
      MrKunjunganConsentTindakanModel(
        data: json["data"] == null
            ? []
            : List<DataKunjunganConsentTindakan>.from(json["data"]!
                .map((x) => DataKunjunganConsentTindakan.fromJson(x))),
        message: json["message"],
      );
}

class DataKunjunganConsentTindakan {
  int? id;
  int? kunjunganId;
  int? pegawaiId;
  String? namaPegawai;
  String? fileName;
  String? sizeFile;
  String? url;
  String? jenis;
  String? createdAt;
  String? extension;

  DataKunjunganConsentTindakan({
    this.id,
    this.kunjunganId,
    this.pegawaiId,
    this.namaPegawai,
    this.fileName,
    this.sizeFile,
    this.url,
    this.jenis,
    this.createdAt,
    this.extension,
  });

  factory DataKunjunganConsentTindakan.fromJson(Map<String, dynamic> json) =>
      DataKunjunganConsentTindakan(
        id: json["id"],
        kunjunganId: json["kunjungan_id"],
        pegawaiId: json["pegawai_id"],
        namaPegawai: json["nama_pegawai"],
        fileName: json["file_name"],
        sizeFile: json["size_file"],
        url: json["url"],
        jenis: json["jenis"],
        createdAt: json["created_at"],
        extension: json["extension"],
      );
}
