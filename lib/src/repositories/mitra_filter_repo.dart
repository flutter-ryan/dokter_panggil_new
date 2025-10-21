import 'package:admin_dokter_panggil/src/models/mitra_filter_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MitraFilterRepo {
  Future<ResponseMitraFilterModel> filterMitra(
      MitraFilterModel mitraFilterModel) async {
    final respose = await dio.post(
        '/v1/master/mitra/filter', mitraFilterModelToJson(mitraFilterModel));
    return responseMitraFilterModelFromJson(respose);
  }
}
