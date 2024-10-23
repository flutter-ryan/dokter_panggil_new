import 'package:dokter_panggil/src/models/master_paket_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterPaketRepo {
  Future<ResponseMasterPaketModel> saveMasterPaket(
      MasterPaketModel masterPaketModel) async {
    final response = await dio.post(
        '/v1/master/paket', masterPaketModelToJson(masterPaketModel));
    return responseMasterPaketModelFromJson(response);
  }

  Future<ResponseMasterPaketModel> updateMasterPaket(
      MasterPaketModel masterPaketModel, int id) async {
    final response = await dio.put(
        '/v1/master/paket/$id', masterPaketModelToJson(masterPaketModel));
    return responseMasterPaketModelFromJson(response);
  }

  Future<ResponseMasterPaketModel> deleteMasterPaket(int id) async {
    final response = await dio.delete('/v1/master/paket/$id');
    return responseMasterPaketModelFromJson(response);
  }
}
