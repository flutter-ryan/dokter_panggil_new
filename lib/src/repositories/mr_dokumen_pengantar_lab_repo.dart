import 'package:dokter_panggil/src/models/mr_dokumen_pengantar_lab_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MrDokumenPengantarLabRepo {
  Future<MrDokumenPengantarLabModel> getDokumenPengantarLab(
      int idPengantar) async {
    final response =
        await dio.get('/v2/mr/laboratorium/tagihan/pengantar/$idPengantar');
    return mrDokumenPengantarLabModelFromJson(response);
  }
}
