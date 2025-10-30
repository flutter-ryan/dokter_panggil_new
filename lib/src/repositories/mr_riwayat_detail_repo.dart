import 'package:admin_dokter_panggil/src/models/mr_riwayat_detail_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrRiwayatDetailRepo {
  Future<MrRiwayatDetailModel> getDetailRiwayat(int idKunjungan) async {
    final response =
        await dio.get('/v2/mr/admin-riwayat-kunjungan/detail/$idKunjungan');
    return mrRiwayatDetailModelFromJson(response);
  }
}
