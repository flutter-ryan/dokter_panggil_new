import 'package:dokter_panggil/src/models/laporan_harian_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class LaporanHarianRepo {
  Future<LaporanHarianModel> getLaporanHarian() async {
    final response = await dio.get('/v1/laporan/harian');
    return laporanHarianModelFromJson(response);
  }

  Future<ResponseLaporanHarianRequestModel> saveLaporanHarian(
      LaporanHarianRequestModel laporanHarianRequestModel) async {
    final response = await dio.post('/v1/laporan/harian',
        laporanHarianRequestModelToJson(laporanHarianRequestModel));
    return responseLaporanHarianRequestModelFromJson(response);
  }
}
