import 'package:admin_dokter_panggil/src/models/mr_hasil_lab_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrHasilLabRepo {
  Future<MrHasilLabModel> getHasilLab(int idKunjungan) async {
    final response = await dio.get('/v2/mr/hasil-lab/$idKunjungan');
    return mrHasilLabModelFromJson(response);
  }
}
