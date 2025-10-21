import 'package:admin_dokter_panggil/src/models/master_bhp_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterBhpSaveRepo {
  Future<ResponseMasterBhpModel> saveBhp(MasterBhpModel masterBhpModel) async {
    final response =
        await dio.post('/v1/master/bhp', masterBhpModelToJson(masterBhpModel));
    return responseMasterBhpModelFromJson(response);
  }
}
