import 'package:admin_dokter_panggil/src/models/mr_kunjungan_skrining_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrKunjunganSkriningRepo {
  Future<MrKunjunganSkriningModel> getSkrining(int idKunjungan) async {
    final response = await dio.get('/v2/mr/skrining/$idKunjungan');
    return mrKunjunganSkriningModelFromJson(response);
  }
}
