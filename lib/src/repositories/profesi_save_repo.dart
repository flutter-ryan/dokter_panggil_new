import 'package:dokter_panggil/src/models/profesi_save_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class ProfesiSaveRepo {
  Future<ResponseProfesiSaveModel> saveProfesi(
      ProfesiSaveModel profesiSaveModel) async {
    final response = await dio.post(
        '/v1/master/profesi', profesiSaveModelToJson(profesiSaveModel));

    return responseProfesiSaveModelFromJson(response);
  }
}
