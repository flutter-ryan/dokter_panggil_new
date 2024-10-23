LaporanJasaDokterModel laporanJasaDokterModelFromJson(dynamic str) =>
    LaporanJasaDokterModel.fromJson(str);

class LaporanJasaDokterModel {
  List<LaporanJasaDokter>? data;
  String? message;

  LaporanJasaDokterModel({
    this.data,
    this.message,
  });

  factory LaporanJasaDokterModel.fromJson(Map<String, dynamic> json) =>
      LaporanJasaDokterModel(
        data: List<LaporanJasaDokter>.from(
            json["data"]!.map((x) => LaporanJasaDokter.fromJson(x))),
        message: json["message"],
      );
}

class LaporanJasaDokter {
  int? id;
  DateTime? from;
  DateTime? to;
  String? url;

  LaporanJasaDokter({
    this.id,
    this.from,
    this.to,
    this.url,
  });

  factory LaporanJasaDokter.fromJson(Map<String, dynamic> json) =>
      LaporanJasaDokter(
        id: json["id"],
        from: json["from"] == null ? null : DateTime.parse(json["from"]),
        to: json["to"] == null ? null : DateTime.parse(json["to"]),
        url: json["url"],
      );
}
