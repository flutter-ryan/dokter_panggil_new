import 'package:admin_dokter_panggil/src/models/master_pegawai_fetch_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterPegawaiFetchRepo {
  Future<MasterPegawaiFetchModel> fetchPegawai() async {
    final response = await dio.get('/v1/master/pegawai/current');
    return masterPegawaiFetchModelFromJson(response);
  }
}
