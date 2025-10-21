import 'package:admin_dokter_panggil/src/models/dokumen_lab_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class DokumenLabSaveRepo {
  Future<DokumenLabSaveModel> saveDokumenLab(
      DokumenLabRequestModel dokumenLabRequestModel, int idPengantar) async {
    final response = await dio.post('/v2/mr/laboratorium/dokumen/$idPengantar',
        dokumenLabRequestModelToJson(dokumenLabRequestModel));
    return dokumenLabSaveModelFromJson(response);
  }

  Future<DokumenLabSaveModel> deleteDokumenLab(int idDokumen) async {
    final response =
        await dio.delete('/v2/mr/laboratorium/dokumen-lab/$idDokumen');
    return dokumenLabSaveModelFromJson(response);
  }
}
