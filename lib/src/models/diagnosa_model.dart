import 'dart:convert';

String diagnosaModelToJson(DiagnosaModel data) => json.encode(data.toJson());

class DiagnosaModel {
  DiagnosaModel({
    required this.diagnosa,
    required this.kode,
  });

  String diagnosa;
  String kode;

  Map<String, dynamic> toJson() => {
        "diagnosa": diagnosa,
        "kode": kode,
      };
}

ResponseDiagnosaModel responseDiagnosaModelFromJson(dynamic str) =>
    ResponseDiagnosaModel.fromJson(str);

class ResponseDiagnosaModel {
  ResponseDiagnosaModel({
    this.message,
  });

  String? message;

  factory ResponseDiagnosaModel.fromJson(Map<String, dynamic> json) =>
      ResponseDiagnosaModel(
        message: json["message"],
      );
}
