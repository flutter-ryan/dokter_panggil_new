import 'package:dokter_panggil/src/models/pegawai_search_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class PegawaiSearchRepo {
  Future<ResultPegawaiSearchModel> filterPegawai(
      PegawaiSearchModel pegawaiSearchModel) async {
    final response = await dio.post('/v1/master/pegawai/search',
        pegawaiSearchModelToJson(pegawaiSearchModel));
    return resultPegawaiSearchModelFromJson(response);
  }
}
