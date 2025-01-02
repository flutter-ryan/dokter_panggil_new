import 'package:dokter_panggil/src/models/dokumen_lab_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class DokumenLabRepo {
  Future<DokumenLabModel> getDokumen(int idKunjungan) async {
    final response =
        await dio.get('/v1/laboratorium/dokumen-lab/view/$idKunjungan');
    return dokumenLabModelFromJson(response);
  }
}
