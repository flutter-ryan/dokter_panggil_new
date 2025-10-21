import 'package:admin_dokter_panggil/src/models/kwitansi_sementara_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class KwitansiSementaraRepo {
  Future<KwitansiSementaraModel> getKwitansiSementara(
      int idKunjungan, int biayaAdmin) async {
    final response = await dio
        .get('/v2/mr/kunjungan/kwitansi-sementara/$idKunjungan/$biayaAdmin');
    return kwitansiSementaraModelFromJson(response);
  }
}
