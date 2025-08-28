import 'package:dokter_panggil/src/models/master_village_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterVillageRepo {
  Future<MasterVillageModel> getMasterVillage(
      MasterVillageRequestModel masterVillageRequestModel) async {
    final response = await dio.post('/v2/mr/master/master-village',
        masterVillageRequestModelToJson(masterVillageRequestModel));
    return masterVillageModelFromJson(response);
  }
}
