import 'package:admin_dokter_panggil/src/models/mr_dokumen_pengantar_rad_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrDokumenPengantarRadRepo {
  Future<MrDokumenPengantarRadModel> getDokumenPengantarRad(
      int idPengantar) async {
    final response =
        await dio.get('/v2/mr/radiologi/tagihan/pengantar/$idPengantar');
    return mrDokumenPengantarRadModelFromJson(response);
  }
}
