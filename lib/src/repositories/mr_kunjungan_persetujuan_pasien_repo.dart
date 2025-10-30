import 'package:admin_dokter_panggil/src/models/mr_kunjungan_persetujuan_pasien_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrKunjunganPersetujuanPasienRepo {
  Future<MrKunjunganPersetujuanPasienModel> getPersetujuan(
      int idKunjungan) async {
    final response = await dio.get('/v2/mr/persetujuan/$idKunjungan');
    return mrKunjunganPersetujuanPasienModelFromJson(response);
  }
}
