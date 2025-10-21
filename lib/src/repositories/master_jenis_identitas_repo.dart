import 'package:admin_dokter_panggil/src/models/master_jenis_identitas_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterJenisIdentitasRepo {
  Future<MasterJenisIdentitasModel> getJenisIdentitas() async {
    final response = await dio.get('/v2/mr/master/master-jenis-identitas');
    return masterJenisIdentitasModelFromJson(response);
  }
}
