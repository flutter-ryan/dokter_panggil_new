import 'package:dokter_panggil/src/models/resume_soap_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class ResumeSoapRepo {
  Future<ResponseResumeSoapModel> getSoapPasien(
      ResumeSoapModel resumeSoapModel) async {
    final response = await dio.post(
        '/v1/pasien/resume/soap', resumeSoapModelToJson(resumeSoapModel));
    return responseResumeSoapModelFromJson(response);
  }
}
