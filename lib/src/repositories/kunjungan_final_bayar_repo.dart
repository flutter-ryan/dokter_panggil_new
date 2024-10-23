import 'package:dokter_panggil/src/models/kunjungan_final_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class KunjunganFinalBayarRepo {
  Future<ResponseKunjunganFinalModel> finalBayarKunjungan(
      KunjunganFinalModel kunjunganFinalModel) async {
    final response = await dio.post('/v1/kunjungan/kwitansi',
        kunjunganFinalModelToJson(kunjunganFinalModel));
    return responseKunjunganFinalModelFromJson(response);
  }
}
