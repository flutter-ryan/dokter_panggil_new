import 'package:admin_dokter_panggil/src/models/update_sip_dokter_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class UpdateSipDokterRepo {
  Future<ResponseUpdateSipDokterModel> updateSip(
      int idPegawai, UpdateSipDokterModel updateSipDokterModel) async {
    final response = await dio.put('/v1/master/pegawai/sip/$idPegawai',
        updateSipDokterModelToJson(updateSipDokterModel));
    return responseUpdateSipDokterModelFromJson(response);
  }
}
