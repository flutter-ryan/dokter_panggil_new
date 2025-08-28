import 'package:dokter_panggil/src/models/mr_pasien_save_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MrPasienSaveRepo {
  Future<MrPasienSaveModel> simpanPasienBaru(
      MrPasienSaveRequestModel mrPasienSaveRequestModel) async {
    final response = await dio.post('/v2/mr/pasien',
        mrPasienSaveRequestModelToJson(mrPasienSaveRequestModel));
    return mrPasienSaveModelFromJson(response);
  }
}
