import 'package:admin_dokter_panggil/src/models/master_tindakan_rad_create_mode.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterTindakanRadCreateRepo {
  Future<MasterTindakanRadCreateModel> getTindakanRad() async {
    final response = await dio.get('/v1/master/tindakan-rad/create');
    return masterTindakanRadCreateModelFromJson(response);
  }
}
