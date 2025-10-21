import 'package:admin_dokter_panggil/src/models/cek_role_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class CekRoleRepo {
  Future<CekRoleModel> cekRole() async {
    final response = await dio.get('/v1/user/cek-role');
    return cekRoleModelFromJson(response);
  }
}
