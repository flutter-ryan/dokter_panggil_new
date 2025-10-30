import 'package:admin_dokter_panggil/src/models/mr_kunjungan_resume_medis_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrKunjunganResumeMedisRepo {
  Future<MrKunjunganResumeMedisModel> getResumeMedis(int idKunjungan) async {
    final response = await dio.get('/v2/mr/resume-medis/$idKunjungan');
    return mrKunjunganResumeMedisModelFromJson(response);
  }
}
