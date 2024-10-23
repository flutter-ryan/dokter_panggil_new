import 'package:dokter_panggil/src/models/master_role_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterRoleRepo {
  Future<MasterRoleModel> getMasterRole() async {
    final response = await dio.get('/v1/master/role');
    return masterRoleModelFromJson(response);
  }

  Future<ResponseMasterRoleRequestModel> saveMasterRole(
      MasterRoleRequestModel masterRoleRequestModel) async {
    final response = await dio.post('/v1/master/role',
        masterRoleRequestModelToJson(masterRoleRequestModel));
    return responseMasterRoleRequestModelFromJson(response);
  }
}
