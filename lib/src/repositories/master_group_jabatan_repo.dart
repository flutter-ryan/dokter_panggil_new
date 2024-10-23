import 'package:dokter_panggil/src/models/master_group_jabatan_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterGroupJabatanRepo {
  Future<MasterGroupJabatanModel> getMasterGroupJabatan() async {
    final response = await dio.get('/v1/master/group-jabatan/create');
    return masterGroupJabatanModelFromJson(response);
  }
}
