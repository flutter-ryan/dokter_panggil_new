import 'dart:convert';

String diagnosaFilterModelToJson(DiagnosaFilterModel data) =>
    json.encode(data.toJson());

class DiagnosaFilterModel {
  DiagnosaFilterModel({
    required this.filter,
  });

  String filter;

  Map<String, dynamic> toJson() => {
        "filter": filter,
      };
}

ResponseDiagnosaFilterModel responseDiagnosaFilterModelFromJson(dynamic str) =>
    ResponseDiagnosaFilterModel.fromJson(str);

class ResponseDiagnosaFilterModel {
  ResponseDiagnosaFilterModel({
    this.diagnosa,
    this.message,
  });

  List<Diagnosa>? diagnosa;
  String? message;

  factory ResponseDiagnosaFilterModel.fromJson(Map<String, dynamic> json) =>
      ResponseDiagnosaFilterModel(
        diagnosa:
            List<Diagnosa>.from(json["data"].map((x) => Diagnosa.fromJson(x))),
        message: json["message"],
      );
}

class Diagnosa {
  Diagnosa({
    this.id,
    this.namaDiagnosa,
    this.kodeIcd10,
  });

  int? id;
  String? namaDiagnosa;
  String? kodeIcd10;

  factory Diagnosa.fromJson(Map<String, dynamic> json) => Diagnosa(
        id: json["id"],
        namaDiagnosa: json["nama_diagnosa"],
        kodeIcd10: json["kode_icd_10"],
      );
}
