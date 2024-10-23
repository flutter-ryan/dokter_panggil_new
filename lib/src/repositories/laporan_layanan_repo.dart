import 'package:dokter_panggil/src/models/laporan_layanan_model.dart';
import 'package:dokter_panggil/src/models/laporan_layanan_save_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class LaporanLayananRepo {
  Future<LaporanLayananModel> getLaporanLayanan() async {
    final response = await dio.get('/v1/laporan/layanan/create');
    return laporanLayananModelFromJson(response);
  }

  Future<ResponseLaporanLayananSaveModel> saveLaporanLayanan(
      LaporanLayananSaveModel laporanLayananSaveModel) async {
    final response = await dio.post('/v1/laporan/layanan',
        laporanLayananSaveModelToJson(laporanLayananSaveModel));
    return responseLaporanLayananSaveModelFromJson(response);
  }
}
