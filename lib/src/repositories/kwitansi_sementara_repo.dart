import 'package:dokter_panggil/src/models/kwitansi_sementara_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class KwitansiSementaraRepo {
  Future<KwitansiSementaraModel> getKwitansiSementara(int idKunjungan) async {
    final response =
        await dio.get('/v2/mr/kunjungan/kwitansi-sementara/$idKunjungan');
    return kwitansiSementaraModelFromJson(response);
  }
}
