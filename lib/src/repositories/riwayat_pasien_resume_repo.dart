import 'package:dokter_panggil/src/models/riwayat_pasien_resume_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class RiwayatPasienResumeRepo {
  Future<RiwayatResumePasienModel> getRiwayatResume(String norm) async {
    final response = await dio.get('/v1/pasien/kunjungan/$norm');
    return riwayatResumePasienModelFromJson(response);
  }
}
