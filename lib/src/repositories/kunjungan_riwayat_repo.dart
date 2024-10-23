import 'package:dokter_panggil/src/models/kunjungan_riwayat_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class KunjunganRiwayatRepo {
  Future<KunjunganRiwayatModel> riwayatKunjungan() async {
    final response = await dio.get('/v1/kunjungan/riwayat');
    return kunjunganRiwayatModelFromJson(response);
  }
}
