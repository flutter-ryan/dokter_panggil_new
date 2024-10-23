import 'package:dokter_panggil/src/models/master_biaya_admin_save_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterBiayaAdminSaveRepo {
  Future<ResponseMasterBiayaAdminSaveModel> saveBiayaAdmin(
      MasterBiayaAdminSaveModel masterBiayaAdminSaveModel) async {
    final response = await dio.post('/v1/master/biaya-admin',
        masterBiayaAdminSaveModelToJson(masterBiayaAdminSaveModel));
    return responseMasterBiayaAdminSaveModelFromJson(response);
  }

  Future<ResponseMasterBiayaAdminSaveModel> updateBiayaAdmin(
      MasterBiayaAdminSaveModel masterBiayaAdminSaveModel, int id) async {
    final response = await dio.put('/v1/master/biaya-admin/$id',
        masterBiayaAdminSaveModelToJson(masterBiayaAdminSaveModel));
    return responseMasterBiayaAdminSaveModelFromJson(response);
  }

  Future<ResponseMasterBiayaAdminSaveModel> deleteBiayaAdmin(int id) async {
    final response = await dio.delete('/v1/master/biaya-admin/$id');
    return responseMasterBiayaAdminSaveModelFromJson(response);
  }
}
