import 'package:admin_dokter_panggil/src/models/mr_kunjungan_edukasi_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrKunjunganEdukasiRepo {
  Future<MrKunjunganEdukasiModel> getEdukasi(int idKunjungan) async {
    final response = await dio.get('/v2/mr/edukasi/$idKunjungan');
    return mrKunjunganEdukasiModelFromJson(response);
  }
}
