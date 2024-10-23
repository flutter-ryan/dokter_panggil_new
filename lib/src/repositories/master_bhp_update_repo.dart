import 'package:dokter_panggil/src/models/master_bhp_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterBhpUpdateRepo {
  Future<ResponseMasterBhpModel> updateMasterBhp(
      int? id, MasterBhpModel masterBhpModel) async {
    final response = await dio.put(
        '/v1/master/bhp/$id', masterBhpModelToJson(masterBhpModel));
    return responseMasterBhpModelFromJson(response);
  }
}
