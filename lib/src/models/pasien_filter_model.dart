import 'dart:convert';

String pasienFilterModelToJson(PasienFilterModel data) =>
    json.encode(data.toJson());

class PasienFilterModel {
  PasienFilterModel({
    this.filter,
  });

  String? filter;

  Map<String, dynamic> toJson() => {
        "filter": filter,
      };
}

ResponsePasienFilterModel responsePasienFilterModelFromJson(dynamic str) =>
    ResponsePasienFilterModel.fromJson(str);

class ResponsePasienFilterModel {
  ResponsePasienFilterModel({
    this.pasien,
    this.message,
  });

  List<PasienFilter>? pasien;
  String? message;

  factory ResponsePasienFilterModel.fromJson(Map<String, dynamic> json) =>
      ResponsePasienFilterModel(
        pasien: List<PasienFilter>.from(
            json["data"].map((x) => PasienFilter.fromJson(x))),
        message: json["message"],
      );
}

class PasienFilter {
  PasienFilter({
    this.id,
    this.norm,
    this.normPanjang,
    this.nama,
    this.umur,
    this.tanggalLahir,
    this.isSuperadmin,
  });

  int? id;
  String? nama;
  String? norm;
  String? normPanjang;
  String? umur;
  DateTime? tanggalLahir;
  bool? isSuperadmin;

  factory PasienFilter.fromJson(Map<String, dynamic> json) => PasienFilter(
        id: json["id"],
        norm: json["norm"],
        normPanjang: json["norm_sprint"],
        nama: json["nama_pasien"],
        umur: json["umur"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        isSuperadmin: json["is_superadmin"],
      );
}
