import 'package:dokter_panggil/src/models/dokumen_lab_save_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class DokumenLabSaveRepo {
  Future<DokumenLabSaveModel> saveDokumenLab(
      DokumenLabRequestModel dokumenLabRequestModel, int idKunjungan) async {
    final response = await dio.post(
        '/v2/mr/pengkajian-dokter/tindakan-lab/hasil-lab/$idKunjungan',
        dokumenLabRequestModelToJson(dokumenLabRequestModel));
    return dokumenLabSaveModelFromJson(response);
  }

  Future<DokumenLabSaveModel> deleteDokumenLab(int idDokumen) async {
    final response =
        await dio.delete('/v2/mr/laboratorium/dokumen-lab/$idDokumen');
    return dokumenLabSaveModelFromJson(response);
  }
}
