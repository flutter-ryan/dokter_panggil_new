import 'package:admin_dokter_panggil/src/models/master_pegawai_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterPegawaiSaveRepo {
  Future<ResponseMasterPegawaiSaveModel> savePegawai(
      MasterPegawaiSaveModel masterPegawaiSaveModel) async {
    final response = await dio.post('/v1/master/pegawai',
        masterPegawaiSaveModelToJson(masterPegawaiSaveModel));
    return responseMasterPegawaiSaveModelFromJson(response);
  }
}
