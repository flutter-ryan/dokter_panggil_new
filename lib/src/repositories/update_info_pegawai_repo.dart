import 'package:admin_dokter_panggil/src/models/update_info_pegawai_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class UpdateInfoPegawaiRepo {
  Future<ResponseUpdateInfoPegawaiModel> updateInfoPegawai(
      int id, UpdateInfoPegawaiModel updateInfoPegawaiModel) async {
    final response = await dio.put('/v1/master/pegawai/informasi/$id',
        updateInfoPegawaiModelToJson(updateInfoPegawaiModel));
    return responseUpdateInfoPegawaiModelFromJson(response);
  }
}
