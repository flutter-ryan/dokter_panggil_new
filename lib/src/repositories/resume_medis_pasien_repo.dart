import 'package:admin_dokter_panggil/src/models/resume_medis_pasien_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class ResumeMedisPasieRepo {
  Future<ResumeMedisPasienModel> getResumeMedis(int idKunjungan) async {
    final res = await dio.get('/v1/pasien/resume/$idKunjungan');
    return resumeMedisPasienModelFromJson(res);
  }
}
