import 'package:dokter_panggil/src/models/kunjungan_resep_racikan_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class KunjunganResepRacikanRepo {
  Future<ResponseKunjunganResepRacikanModel> getKunjunganResepRacikan(
      KunjunganResepRacikanModel kunjunganResepRacikanModel) async {
    final response = await dio.post(
        '/v1/layanan-kunjungan/resep-racikan/create',
        kunjunganResepRacikanModelToJson(kunjunganResepRacikanModel));

    return responseKunjunganResepRacikanModelFromJson(response);
  }
}
