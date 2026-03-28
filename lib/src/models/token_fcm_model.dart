import 'dart:convert';

TokenFcmModel tokenFcmModelFromJson(dynamic str) => TokenFcmModel.fromJson(str);

class TokenFcmModel {
  TokenFcm? data;
  String? message;

  TokenFcmModel({
    this.data,
    this.message,
  });

  factory TokenFcmModel.fromJson(Map<String, dynamic> json) => TokenFcmModel(
        data: json["data"] == null ? null : TokenFcm.fromJson(json["data"]),
        message: json["message"],
      );
}

class TokenFcm {
  String? token;

  TokenFcm({
    this.token,
  });

  factory TokenFcm.fromJson(Map<String, dynamic> json) => TokenFcm(
        token: json["token"],
      );
}

String tokenFcmRequestModelToJson(TokenFcmRequestModel data) =>
    json.encode(data.toJson());

class TokenFcmRequestModel {
  String token;

  TokenFcmRequestModel({
    required this.token,
  });

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}
