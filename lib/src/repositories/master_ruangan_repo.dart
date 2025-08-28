import 'package:dokter_panggil/src/models/master_ruangan_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterRuanganRepo {
  Future<MasterRuanganModel> getMasterRuangan() async {
    final response = await dio.get('/v2/mr/master/master-ruangan');
    return masterRuanganModelFromJson(response);
  }
}
