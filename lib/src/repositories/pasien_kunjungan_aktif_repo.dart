import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class PasienKunjunganAktifRepo {
  Future<PasienKunjunganModel> kunjunganAktif(String? norm) async {
    final response = await dio.get('/v1/pasien/kunjungan/aktif/$norm');
    return pasienKunjunganModelFromJson(response);
  }
}
