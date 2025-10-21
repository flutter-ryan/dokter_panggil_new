import 'package:admin_dokter_panggil/src/models/master_diskon_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterDiskonSaveRepo {
  Future<ResponseMasterDiskonSaveModel> saveMasterDiskon(
      MasterDiskonSaveModel masterDiskonSaveModel) async {
    final response = await dio.post('/v1/master/diskon',
        masterDiskonSaveModelToJson(masterDiskonSaveModel));
    return responseMasterDiskonSaveModelFromJson(response);
  }

  Future<ResponseMasterDiskonSaveModel> updateMasterDiskon(
      MasterDiskonSaveModel masterDiskonSaveModel, int id) async {
    final response = await dio.put('/v1/master/diskon/$id',
        masterDiskonSaveModelToJson(masterDiskonSaveModel));
    return responseMasterDiskonSaveModelFromJson(response);
  }

  Future<ResponseMasterDiskonSaveModel> deleteMasterDiskon(int id) async {
    final response = await dio.delete('/v1/master/diskon/$id');
    return responseMasterDiskonSaveModelFromJson(response);
  }
}
