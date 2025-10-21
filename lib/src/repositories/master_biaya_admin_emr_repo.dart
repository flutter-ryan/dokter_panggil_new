import 'package:admin_dokter_panggil/src/models/master_biaya_admin_emr_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterBiayaAdminEmrRepo {
  Future<MasterBiayaAdminEmrModel> biayaAdminEmr(
      MasterBiayaAdminEmrRequestModel masterBiayaAdminEmrRequestModel) async {
    final response = await dio.post('/v2/mr/master/biaya-admin',
        masterBiayaAdminEmrRequestModelToJson(masterBiayaAdminEmrRequestModel));
    return masterBiayaAdminEmrModelFromJson(response);
  }
}
