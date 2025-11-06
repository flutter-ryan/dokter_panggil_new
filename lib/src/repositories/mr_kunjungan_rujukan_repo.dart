import 'package:admin_dokter_panggil/src/models/mr_kunjungan_rujukan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrKunjunganRujukanRepo {
  Future<MrKunjunganRujukanModel> getRujukan(int idKunjungan) async {
    final response = await dio.get('/v2/mr/rujukan/$idKunjungan');
    return mrKunjunganRujukanModelFromJson(response);
  }
}
