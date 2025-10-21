import 'package:admin_dokter_panggil/src/models/kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class KunjunganRepo {
  Future<KunjunganModel> getKunjungan() async {
    final response = await dio.get('/v1/kunjungan/create');
    return kunjunganModelFromJson(response);
  }
}
