import 'dart:convert';

String pegawaiSearchModelToJson(PegawaiSearchModel data) =>
    json.encode(data.toJson());

class PegawaiSearchModel {
  PegawaiSearchModel({
    required this.filter,
  });

  String filter;

  Map<String, dynamic> toJson() => {
        "filter": filter,
      };
}

ResultPegawaiSearchModel resultPegawaiSearchModelFromJson(dynamic str) =>
    ResultPegawaiSearchModel.fromJson(str);

class ResultPegawaiSearchModel {
  ResultPegawaiSearchModel({
    this.result,
    this.message,
  });

  List<ResultPegawai>? result;
  String? message;

  factory ResultPegawaiSearchModel.fromJson(Map<String, dynamic> json) =>
      ResultPegawaiSearchModel(
        result: List<ResultPegawai>.from(
            json["data"].map((x) => ResultPegawai.fromJson(x))),
        message: json["message"],
      );
}

class ResultPegawai {
  ResultPegawai({
    this.id,
    this.nama,
    this.profesi,
    this.namaProfesi,
  });

  int? id;
  String? nama;
  ProfesiPegawai? profesi;
  String? namaProfesi;

  factory ResultPegawai.fromJson(Map<String, dynamic> json) => ResultPegawai(
        id: json["id"],
        nama: json["nama"],
        profesi: ProfesiPegawai.fromJson(json["profesi"]),
        namaProfesi: json["nama_profesi"],
      );
}

class ProfesiPegawai {
  ProfesiPegawai({
    this.id,
    this.namaJabatan,
  });

  int? id;
  String? namaJabatan;

  factory ProfesiPegawai.fromJson(Map<String, dynamic> json) => ProfesiPegawai(
        id: json["id"],
        namaJabatan: json["nama_jabatan"],
      );
}
