import 'package:dokter_panggil/src/models/dokumen_lab_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class DokumenLabRepo {
  Future<DokumenLabModel> getDokumen(int idPengantar) async {
    final response = await dio.get('/v2/mr/laboratorium/dokumen/$idPengantar');
    return dokumenLabModelFromJson(response);
  }
}
