import 'package:admin_dokter_panggil/src/models/master_layanan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterLayananRepo {
  Future<MasterLayananModel> getMasterLayanan() async {
    final response = await dio.get('/v2/mr/master-layanan');
    return masterLayananModelFromJson(response);
  }
}
