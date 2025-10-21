import 'package:admin_dokter_panggil/src/models/dokumen_rad_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class DokumenRadRepo {
  Future<DokumenRadModel> getDokumenRad(int idPengantar) async {
    final response = await dio.get('/v2/mr/radiologi/dokumen/$idPengantar');
    return dokumenRadModelFromJson(response);
  }
}
