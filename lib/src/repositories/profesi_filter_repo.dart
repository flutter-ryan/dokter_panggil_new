import 'package:admin_dokter_panggil/src/models/profesi_filter_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class ProfesiFilterRepo {
  Future<ResponseProfesiFilterModel> filterProfesi(
      ProfesiFilterModel profesiFilterModel) async {
    final response = await dio.post('/v1/master/profesi/filter',
        profesiFilterModelToJson(profesiFilterModel));
    return responseProfesiFilterModelFromJson(response);
  }
}
