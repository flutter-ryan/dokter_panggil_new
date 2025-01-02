import 'package:dokter_panggil/src/models/resep_injeksi_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class ResepInjeksiRepo {
  Future<ResepInjeksiModel> getResepInjeksi(
      ResepInjeksiRequestModel resepInjeksiRequestModel) async {
    final response = await dio.post('/v2/mr/resep/injeksi',
        resepInjeksiRequestModelToJson(resepInjeksiRequestModel));
    return resepInjeksiModelFromJson(response);
  }
}
