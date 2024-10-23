import 'dart:convert';

String tindakanModelToJson(TindakanModel data) => json.encode(data.toJson());

class TindakanModel {
  TindakanModel({
    required this.tindakan,
    required this.tarifTindakan,
    required this.jasaDokter,
    required this.bayarLangsung,
    required this.transportasi,
    required this.gojek,
    this.idGroup,
  });

  String tindakan;
  int tarifTindakan;
  int jasaDokter;
  bool bayarLangsung;
  bool transportasi;
  bool gojek;
  int? idGroup;

  Map<String, dynamic> toJson() => {
        "tindakan": tindakan,
        "tarifTindakan": tarifTindakan,
        "jasaDokter": jasaDokter,
        "langsung": bayarLangsung,
        "transportasi": transportasi,
        "gojek": gojek,
        "idGroup": idGroup,
      };
}

ResponseTindakanModel responseTindakanModelFromJson(dynamic str) =>
    ResponseTindakanModel.fromJson(str);

class ResponseTindakanModel {
  ResponseTindakanModel({
    this.message,
  });

  String? message;

  factory ResponseTindakanModel.fromJson(Map<String, dynamic> json) =>
      ResponseTindakanModel(
        message: json["message"],
      );
}
