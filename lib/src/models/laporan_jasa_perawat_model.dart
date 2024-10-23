LaporanJasaPerawatModel laporanJasaPerawatModelFromJson(dynamic str) =>
    LaporanJasaPerawatModel.fromJson(str);

class LaporanJasaPerawatModel {
  List<LaporanJasaPerawat>? data;
  String? message;

  LaporanJasaPerawatModel({
    this.data,
    this.message,
  });

  factory LaporanJasaPerawatModel.fromJson(Map<String, dynamic> json) =>
      LaporanJasaPerawatModel(
        data: List<LaporanJasaPerawat>.from(
            json["data"]!.map((x) => LaporanJasaPerawat.fromJson(x))),
        message: json["message"],
      );
}

class LaporanJasaPerawat {
  int? id;
  DateTime? from;
  DateTime? to;
  String? url;

  LaporanJasaPerawat({
    this.id,
    this.from,
    this.to,
    this.url,
  });

  factory LaporanJasaPerawat.fromJson(Map<String, dynamic> json) =>
      LaporanJasaPerawat(
        id: json["id"],
        from: json["from"] == null ? null : DateTime.parse(json["from"]),
        to: json["to"] == null ? null : DateTime.parse(json["to"]),
        url: json["url"],
      );
}
