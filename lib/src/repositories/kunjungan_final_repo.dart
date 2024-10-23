import 'package:dokter_panggil/src/models/kunjungan_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class KunjunganFinalRepo {
  Future<KunjunganModel> kunjunganFinal() async {
    final response = await dio.get('/v1/kunjungan/final');
    return kunjunganModelFromJson(response);
  }
}
