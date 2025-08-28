import 'package:dokter_panggil/src/models/mr_pasien_save_model.dart';
import 'package:dokter_panggil/src/models/pasien_show_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MrPasienUpdateRepo {
  Future<PasienShowModel> updatePasienBaru(
      MrPasienSaveRequestModel mrPasienSaveRequestModel, int idPasien) async {
    final response = await dio.put('/v2/mr/pasien/$idPasien',
        mrPasienSaveRequestModelToJson(mrPasienSaveRequestModel));
    return pasienShowModelFromJson(response);
  }
}
