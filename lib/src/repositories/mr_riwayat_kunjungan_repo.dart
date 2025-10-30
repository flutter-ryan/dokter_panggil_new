import 'package:admin_dokter_panggil/src/models/mr_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrRiwayatKunjunganRepo {
  Future<MrRiwayatKunjunganModel> getRiwayatKunjungan(
      String norm, int page) async {
    final response =
        await dio.get('/v2/mr/admin-riwayat-kunjungan/$norm?page=$page');
    return mrRiwayatKunjunganModelFromJson(response);
  }
}
