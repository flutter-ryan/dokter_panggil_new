import 'package:dokter_panggil/src/models/master_tindakan_lab_save_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterTindakanLabSaveRepo {
  Future<ResponseMasterTindakanLabSaveModel> saveTindakanLab(
      MasterTindakanLabSaveModel masterTindakanLabSaveModel) async {
    final response = await dio.post('/v1/master/tindakan-lab',
        masterTindakanLabSaveModelToJson(masterTindakanLabSaveModel));
    return responseMasterTindakanLabSaveModelFromJson(response);
  }

  Future<ResponseMasterTindakanLabSaveModel> updateTindakanLab(
      MasterTindakanLabSaveModel masterTindakanLabSaveModel, int id) async {
    final response = await dio.put('/v1/master/tindakan-lab/$id',
        masterTindakanLabSaveModelToJson(masterTindakanLabSaveModel));
    return responseMasterTindakanLabSaveModelFromJson(response);
  }

  Future<ResponseMasterTindakanLabSaveModel> deleteTindakanLab(int id) async {
    final response = await dio.delete('/v1/master/tindakan-lab/$id');
    return responseMasterTindakanLabSaveModelFromJson(response);
  }
}
