import 'package:admin_dokter_panggil/src/models/pendaftaran_kunjungan_nonkonsul_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class PendaftaranKunjunganNonkonsulSaveRepo {
  Future<ResponsePendaftaranKunjunganNonkonsulSaveModel> saveKunjunganNonKonsul(
      PendaftaranKunjunganNonkonsulSaveModel
          pendaftaranKunjunganNonkonsulSaveModel) async {
    final response = await dio.post(
        '/v1/kunjungan/non-konsul',
        pendaftaranKunjunganNonkonsulSaveModelToJson(
            pendaftaranKunjunganNonkonsulSaveModel));
    return responsePendaftaranKunjunganNonkonsulSaveModelFromJson(response);
  }
}
