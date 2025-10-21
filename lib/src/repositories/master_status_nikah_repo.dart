import 'package:admin_dokter_panggil/src/models/master_status_nikah_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterStatusNikahRepo {
  Future<MasterStatusNikahModel> getStatusNikah() async {
    final response = await dio.get('/v2/mr/master/master-status');
    return masterStatusNikahModelFromJson(response);
  }
}
