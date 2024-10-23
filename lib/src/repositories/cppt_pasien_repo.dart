import 'package:dokter_panggil/src/models/cppt_pasien_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class CpptPasienRepo {
  Future<CpptPasienModel> getCpptPasien(
      CpptPasienRequestModel cpptPasienRequestModel) async {
    final response = await dio.post('/v1/pasien/resume/cppt',
        cpptPasienRequestModelToJson(cpptPasienRequestModel));
    return cpptPasienModelFromJson(response);
  }
}
