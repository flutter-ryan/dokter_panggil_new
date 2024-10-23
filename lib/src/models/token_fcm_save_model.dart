import 'dart:convert';

String tokenFcmSaveModelToJson(TokenFcmSaveModel data) =>
    json.encode(data.toJson());

class TokenFcmSaveModel {
  String token;

  TokenFcmSaveModel({
    required this.token,
  });

  factory TokenFcmSaveModel.fromJson(Map<String, dynamic> json) =>
      TokenFcmSaveModel(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}

ResponseTokenFcmSaveModel responseTokenFcmSaveModelFromJson(dynamic str) =>
    ResponseTokenFcmSaveModel.fromJson(str);

class ResponseTokenFcmSaveModel {
  TokenFcmData? data;
  String? message;

  ResponseTokenFcmSaveModel({
    this.data,
    this.message,
  });

  factory ResponseTokenFcmSaveModel.fromJson(Map<String, dynamic> json) =>
      ResponseTokenFcmSaveModel(
        data: TokenFcmData.fromJson(json["data"]),
        message: json["message"],
      );
}

class TokenFcmData {
  String? token;

  TokenFcmData({
    this.token,
  });

  factory TokenFcmData.fromJson(Map<String, dynamic> json) => TokenFcmData(
        token: json["token"],
      );
}
