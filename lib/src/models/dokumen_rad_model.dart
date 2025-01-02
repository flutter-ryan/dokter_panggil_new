DokumenRadModel dokumenRadModelFromJson(dynamic str) =>
    DokumenRadModel.fromJson(str);

class DokumenRadModel {
  List<DokumenRad>? data;
  String? message;

  DokumenRadModel({
    this.data,
    this.message,
  });

  factory DokumenRadModel.fromJson(Map<String, dynamic> json) =>
      DokumenRadModel(
        data: json["data"] == null
            ? []
            : List<DokumenRad>.from(
                json["data"]!.map((x) => DokumenRad.fromJson(x))),
        message: json["message"],
      );
}

class DokumenRad {
  int? id;
  String? namaFile;
  String? url;
  String? ext;
  String? confirmedBy;
  String? confirmedAt;
  String? createdAt;

  DokumenRad({
    this.id,
    this.namaFile,
    this.url,
    this.ext,
    this.confirmedBy,
    this.confirmedAt,
    this.createdAt,
  });

  factory DokumenRad.fromJson(Map<String, dynamic> json) => DokumenRad(
        id: json["id"],
        namaFile: json["nama_file"],
        url: json["url"],
        ext: json["ext"],
        confirmedBy: json["confirmed_by"],
        confirmedAt: json["confirmed_at"],
        createdAt: json["created_at"],
      );
}
