import 'package:admin_dokter_panggil/src/models/laporan_jasa_perawat_model.dart';
import 'package:admin_dokter_panggil/src/models/laporan_jasa_perawat_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class LaporanJasaPerawatRepo {
  Future<LaporanJasaPerawatModel> getLaporanJasaPerawat() async {
    final response = await dio.get('/v1/laporan/jasa-perawat/create');
    return laporanJasaPerawatModelFromJson(response);
  }

  Future<ResponseLaporanJasaPerawatSaveModel> saveLaporanJasaPerawat(
      LaporanJasaPerawatSaveModel laporanJasaPerawatSaveModel) async {
    final response = await dio.post('/v1/laporan/jasa-perawat',
        laporanJasaPerawatSaveModelToJson(laporanJasaPerawatSaveModel));
    return responseLaporanJasaPerawatSaveModelFromJson(response);
  }
}
