import 'package:admin_dokter_panggil/src/models/laporan_jasa_dokter_model.dart';
import 'package:admin_dokter_panggil/src/models/laporan_jasa_dokter_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class LaporanJasaDokterRepo {
  Future<LaporanJasaDokterModel> createLaporanJasa() async {
    final response = await dio.get('/v1/laporan/jasa-dokter/create');
    return laporanJasaDokterModelFromJson(response);
  }

  Future<ResponseLaporanJasaDokterSaveModel> saveLaporanJasa(
      LaporanJasaDokterSaveModel laporanJasaDokterSaveModel) async {
    final response = await dio.post('/v1/laporan/jasa-dokter',
        laporanJasaDokterSaveModelToJson(laporanJasaDokterSaveModel));
    return responseLaporanJasaDokterSaveModelFromJson(response);
  }
}
