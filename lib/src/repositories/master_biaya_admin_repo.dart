import 'package:admin_dokter_panggil/src/models/master_biaya_admin_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterBiayaAdminRepo {
  Future<MasterBiayaAdminModel> createMasterBiayaAdmin() async {
    final response = await dio.get('/v1/master/biaya-admin/create');
    return masterBiayaAdminModelFromJson(response);
  }
}
