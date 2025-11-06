import 'package:admin_dokter_panggil/src/models/new_resume_medis_pasien_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class NewResumeMedisPasienRepo {
  Future<NewResumeMedisPasienModel> getResumePasien(int idKunjungan) async {
    final response = await dio.get('/v2/resume-medis/$idKunjungan');
    return newResumeMedisPasienModelFromJson(response);
  }
}
