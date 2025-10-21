import 'package:admin_dokter_panggil/src/models/resume_pemeriksaan_pasien_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class ResumePemeriksaanPasienRepo {
  Future<ResponseResumePemeriksaanPasienModel> getResumePemeriksaanPasien(
      ResumePemeriksaanPasienModel resumePemeriksaanPasienModel) async {
    final response = await dio.post('/v1/pasien/resume/pemeriksaan-pasien',
        resumePemeriksaanPasienModelToJson(resumePemeriksaanPasienModel));
    return responseResumePemeriksaanPasienModelFromJson(response);
  }
}
