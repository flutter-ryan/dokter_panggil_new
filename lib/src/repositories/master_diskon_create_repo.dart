import 'package:admin_dokter_panggil/src/models/master_diskon_create_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterDiskonCreateRepo {
  Future<ResponseMasterDiskonCreateModel> getMasterDiskon(
      MasterDiskonCreateModel masterDiskonCreateModel) async {
    final response = await dio.post('/v1/master/diskon/search',
        masterDiskonCreateModelToJson(masterDiskonCreateModel));
    return responseMasterDiskonCreateModelFromJson(response);
  }
}
