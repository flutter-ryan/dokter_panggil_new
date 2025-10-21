import 'package:admin_dokter_panggil/src/models/profesi_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class ProfesiDeleteRepo {
  Future<ResponseProfesiSaveModel> deleteProfesi(int? id) async {
    final response = await dio.delete('/v1/master/profesi/$id');
    return responseProfesiSaveModelFromJson(response);
  }
}
