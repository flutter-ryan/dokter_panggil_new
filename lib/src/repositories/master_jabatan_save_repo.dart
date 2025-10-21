import 'package:admin_dokter_panggil/src/models/master_jabatan_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterJabatanSaveRepo {
  Future<ResponseMasterJabatanSaveModel> saveMasterJabatan(
      MasterJabatanSaveModel masterJabatanSaveModel) async {
    final response = await dio.post('/v1/master/jabatan',
        masterJabatanSaveModelToJson(masterJabatanSaveModel));
    return responseMasterJabatanSaveModelFromJson(response);
  }
}
