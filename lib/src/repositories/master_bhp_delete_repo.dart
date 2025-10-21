import 'package:admin_dokter_panggil/src/models/master_bhp_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterBhpDeleteRepo {
  Future<ResponseMasterBhpModel> deleteMasterBhp(int? id) async {
    final response = await dio.delete('/v1/master/bhp/$id');
    return responseMasterBhpModelFromJson(response);
  }
}
