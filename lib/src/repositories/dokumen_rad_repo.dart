import 'package:dokter_panggil/src/models/dokumen_rad_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class DokumenRadRepo {
  Future<DokumenRadModel> getDokumenRad(int idKunjungan) async {
    final response =
        await dio.get('/v2/mr/radiologi/dokumen-rad/view/$idKunjungan');
    return dokumenRadModelFromJson(response);
  }
}
