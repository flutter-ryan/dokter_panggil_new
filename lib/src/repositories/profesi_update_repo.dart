import 'package:dokter_panggil/src/models/profesi_save_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class ProfesiUpdateRepo {
  Future<ResponseProfesiSaveModel> updateProfesi(
      int? id, ProfesiSaveModel profesiSaveModel) async {
    final response = await dio.put(
        '/v1/master/profesi/$id', profesiSaveModelToJson(profesiSaveModel));
    return responseProfesiSaveModelFromJson(response);
  }
}
