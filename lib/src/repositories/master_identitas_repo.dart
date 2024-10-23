import 'package:dokter_panggil/src/models/master_identitas_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterIdentitasRepo {
  Future<MasterIdentitasModel> getMasterIdentitas(
      MasterIdentitasFilterModel masterIdentitasFilterModel) async {
    final response = await dio.post('/v1/master/identitas/search',
        masterIdentitasFilterModelToJson(masterIdentitasFilterModel));
    return masterIdentitasModelFromJson(response);
  }

  Future<ResponseMasterIdentitasRequestModel> saveMasteridentitas(
      MasterIdentitasRequestModel masterIdentitasRequestModel) async {
    final response = await dio.post('/v1/master/identitas',
        masterIdentitasRequestModelToJson(masterIdentitasRequestModel));
    return responseMasterIdentitasRequestModelFromJson(response);
  }

  Future<ResponseMasterIdentitasRequestModel> updateMasterIdentitas(
      MasterIdentitasRequestModel masterIdentitasRequestModel,
      int idIdentitas) async {
    final response = await dio.put('/v1/master/identitas/$idIdentitas',
        masterIdentitasRequestModelToJson(masterIdentitasRequestModel));
    return responseMasterIdentitasRequestModelFromJson(response);
  }

  Future<ResponseMasterIdentitasRequestModel> deleteMasterIdentitas(
      int idIdentitas) async {
    final response = await dio.delete('/v1/master/identitas/$idIdentitas');
    return responseMasterIdentitasRequestModelFromJson(response);
  }
}
