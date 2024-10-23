import 'package:dokter_panggil/src/models/master_farmasi_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterFarmasiRepo {
  Future<ResponseMasterFarmasiModel> saveFarmasi(
      MasterFarmasiModel masterFarmasiModel) async {
    final response = await dio.post(
        '/v1/master/farmasi', masterFarmasiModelToJson(masterFarmasiModel));
    return responseMasterFarmasiModelFromJson(response);
  }

  Future<ResponseMasterFarmasiModel> updateFarmasi(
      int id, MasterFarmasiModel masterFarmasiModel) async {
    final response = await dio.put(
        '/v1/master/farmasi/$id', masterFarmasiModelToJson(masterFarmasiModel));
    return responseMasterFarmasiModelFromJson(response);
  }

  Future<ResponseMasterFarmasiModel> deleteFarmasi(int id) async {
    final response = await dio.delete('/v1/master/farmasi/$id');
    return responseMasterFarmasiModelFromJson(response);
  }
}
