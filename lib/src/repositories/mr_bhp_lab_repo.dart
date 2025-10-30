import 'package:admin_dokter_panggil/src/models/mr_bhp_lab_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrBhpLabRepo {
  Future<MrBhpLabModel> getBhpLab(int idKunjungan) async {
    final response = await dio.get('/v2/mr/bhp-lab/$idKunjungan');
    return mrBhpLabModelFromJson(response);
  }
}
