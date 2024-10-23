import 'package:dokter_panggil/src/models/master_tindakan_rad_save_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterTindakanRadSaveRepo {
  Future<ResponseMasterTindakanRadSaveModel> saveTindakanRad(
      MasterTindakanRadSaveModel masterTindakanRadSaveModel) async {
    final response = await dio.post('/v1/master/tindakan-rad',
        masterTindakanRadSaveModelToJson(masterTindakanRadSaveModel));
    return responseMasterTindakanRadSaveModelFromJson(response);
  }

  Future<ResponseMasterTindakanRadSaveModel> updateTindakanRad(
      MasterTindakanRadSaveModel masterTindakanRadSaveModel, int? id) async {
    final response = await dio.put('/v1/master/tindakan-rad/$id',
        masterTindakanRadSaveModelToJson(masterTindakanRadSaveModel));
    return responseMasterTindakanRadSaveModelFromJson(response);
  }

  Future<ResponseMasterTindakanRadSaveModel> deleteTindakanRad(int id) async {
    final response = await dio.delete('/v1/master/tindakan-rad/$id');
    return responseMasterTindakanRadSaveModelFromJson(response);
  }
}
