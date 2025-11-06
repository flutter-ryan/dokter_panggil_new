import 'package:admin_dokter_panggil/src/models/mr_kunjungan_implementasi_keperawatan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrKunjunganImplementasiKeperawatanRepo {
  Future<MrKunjunganImplementasiKeperawatanModel> getImplementasiKeperawatan(
      int idKunjungan) async {
    final response =
        await dio.get('/v2/mr/implementasi-keperawatan/$idKunjungan');
    return mrKunjunganImplementasiKeperawatanModelFromJson(response);
  }
}
