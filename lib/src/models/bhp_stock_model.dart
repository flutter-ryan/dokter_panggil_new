import 'dart:convert';

String bhpStockModelToJson(BhpStockModel data) => json.encode(data.toJson());

class BhpStockModel {
  BhpStockModel({
    required this.action,
    required this.stok,
  });

  String action;
  int stok;

  Map<String, dynamic> toJson() => {
        "action": action,
        "stok": stok,
      };
}

ResponseBhpStockModel responseBhpStockModelFromJson(dynamic str) =>
    ResponseBhpStockModel.fromJson(str);

class ResponseBhpStockModel {
  ResponseBhpStockModel({
    this.message,
  });

  String? message;

  factory ResponseBhpStockModel.fromJson(Map<String, dynamic> json) =>
      ResponseBhpStockModel(
        message: json["message"],
      );
}
