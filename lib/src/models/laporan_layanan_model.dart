LaporanLayananModel laporanLayananModelFromJson(dynamic str) =>
    LaporanLayananModel.fromJson(str);

class LaporanLayananModel {
  List<LaporanLayanan>? data;
  String? message;

  LaporanLayananModel({
    this.data,
    this.message,
  });

  factory LaporanLayananModel.fromJson(Map<String, dynamic> json) =>
      LaporanLayananModel(
        data: List<LaporanLayanan>.from(
            json["data"].map((x) => LaporanLayanan.fromJson(x))),
        message: json["message"],
      );
}

class LaporanLayanan {
  int? id;
  DateTime? from;
  DateTime? to;
  String? url;

  LaporanLayanan({
    this.id,
    this.from,
    this.to,
    this.url,
  });

  factory LaporanLayanan.fromJson(Map<String, dynamic> json) => LaporanLayanan(
        id: json["id"],
        from: json["from"] == null ? null : DateTime.parse(json["from"]),
        to: json["to"] == null ? null : DateTime.parse(json["to"]),
        url: json["url"],
      );
}
