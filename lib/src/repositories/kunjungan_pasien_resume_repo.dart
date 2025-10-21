import 'package:admin_dokter_panggil/src/models/kunjungan_pasien_resume_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class KunjunganPasienResumeRepo {
  Future<KunjunganPasienResumeModel> getKunjunganPasienResume(
      String norm,
      int initialPage,
      PencarianRiwayatResumeModel pencarianRiwayatResumeModel) async {
    final response = await dio.put(
        '/v1/pasien/kunjungan-resume/$norm?page=$initialPage',
        pencarianRiwayatResumeModelToJson(pencarianRiwayatResumeModel));
    return kunjunganPasienResumeModelFromJson(response);
  }
}
