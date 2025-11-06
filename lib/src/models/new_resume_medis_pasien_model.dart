import 'package:admin_dokter_panggil/src/models/kunjungan_pasien_resume_model.dart';

NewResumeMedisPasienModel newResumeMedisPasienModelFromJson(dynamic str) =>
    NewResumeMedisPasienModel.fromJson(str);

class NewResumeMedisPasienModel {
  KunjunganPasienResume? data;
  String? message;

  NewResumeMedisPasienModel({
    this.data,
    this.message,
  });

  factory NewResumeMedisPasienModel.fromJson(Map<String, dynamic> json) =>
      NewResumeMedisPasienModel(
        data: json["data"] == null
            ? null
            : KunjunganPasienResume.fromJson(json["data"]),
        message: json["message"],
      );
}
