import 'package:admin_dokter_panggil/src/models/mr_kunjungan_pengobatan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrKunjunganPengobatanRepo {
  Future<MrKunjunganPengobatanModel> getPengbatan(
      int idKunjungan, String jenis) async {
    final response =
        await dio.get('/v2/mr/daftar-pengobatan/$idKunjungan/$jenis');
    return mrKunjunganPengobatanModelFromJson(response);
  }
}
