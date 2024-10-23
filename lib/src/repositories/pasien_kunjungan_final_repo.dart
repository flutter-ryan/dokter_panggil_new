import 'package:dokter_panggil/src/models/pasien_kunjungan_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class PasienKunjunganFinalRepo {
  Future<PasienKunjunganModel> kunjunganFinal(String? norm) async {
    final response = await dio.get('/v1/pasien/kunjungan/final/$norm');
    return pasienKunjunganModelFromJson(response);
  }
}
