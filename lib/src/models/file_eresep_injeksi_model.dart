FileEresepInjeksiModel fileEresepInjeksiModelFromJson(dynamic str) =>
    FileEresepInjeksiModel.fromJson(str);

class FileEresepInjeksiModel {
  EresepInjeksi? data;
  String? message;

  FileEresepInjeksiModel({
    this.data,
    this.message,
  });

  factory FileEresepInjeksiModel.fromJson(Map<String, dynamic> json) =>
      FileEresepInjeksiModel(
        data:
            json["data"] == null ? null : EresepInjeksi.fromJson(json["data"]),
        message: json["message"],
      );
}

class EresepInjeksi {
  int? id;
  int? resepId;
  String? pasien;
  String? url;

  EresepInjeksi({
    this.id,
    this.resepId,
    this.pasien,
    this.url,
  });

  factory EresepInjeksi.fromJson(Map<String, dynamic> json) => EresepInjeksi(
        id: json["id"],
        resepId: json["resep_id"],
        pasien: json["pasien"],
        url: json["url"],
      );
}
