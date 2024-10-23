import 'package:dokter_panggil/src/models/master_jabatan_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterJabatanRepo {
  Future<MasterJabatanModel> getJabatan() async {
    final response = await dio.get('/v1/master/jabatan/create');
    return masterJabatanModelFromJson(response);
  }
}
