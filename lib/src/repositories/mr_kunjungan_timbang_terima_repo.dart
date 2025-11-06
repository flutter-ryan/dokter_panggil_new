import 'package:admin_dokter_panggil/src/models/mr_kunjungan_timbang_terima_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrKunjunganTimbangTerimaRepo {
  Future<MrKunjunganTimbangTerimaModel> getTimbangTerima(
      int idKunjungan) async {
    final response = await dio.get('/v2/mr/timbang-terima/$idKunjungan');
    return mrKunjunganTimbangTerimaModelFromJson(response);
  }
}
