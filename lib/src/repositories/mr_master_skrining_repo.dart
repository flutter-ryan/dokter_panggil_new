import 'package:dokter_panggil/src/models/mr_master_skrining_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MrMasterSkriningRepo {
  Future<MrMasterSkriningModel> getMasterSkrining(
      MrMasterSkriningRequestModel mrMasterSkriningRequestModel) async {
    final response = await dio.post('/v2/master/skrining',
        mrMasterSkriningRequestModelToJson(mrMasterSkriningRequestModel));
    return mrMasterSkriningModelFromJson(response);
  }
}
