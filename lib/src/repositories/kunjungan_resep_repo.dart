import 'package:admin_dokter_panggil/src/models/kunjungan_resep_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class KunjunganResepRepo {
  Future<ResponseKunjunganResepModel> getKunjunganResep(
      KunjunganResepModel kunjunganResepModel) async {
    final response = await dio.post('/v1/layanan-kunjungan/resep/create',
        kunjunganResepModelToJson(kunjunganResepModel));
    return responseKunjunganResepModelFromJson(response);
  }
}
