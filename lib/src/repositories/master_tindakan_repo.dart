import 'package:admin_dokter_panggil/src/models/master_tindakan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterTindakanRepo {
  Future<MasterTindakanModel> fetchMasterTindakan() async {
    final response = await dio.get('/v1/master/tindakan/create');
    return masterTindakanModelFromJson(response);
  }
}
