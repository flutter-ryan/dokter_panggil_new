import 'package:dokter_panggil/src/models/dokumen_rad_save_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class DokumenRadSaveRepo {
  Future<DokumenRadSaveModel> uploadDokumenRad(
      DokumenRadRequestModel dokumenRadRequestModel, int idPengantar) async {
    final response = await dio.post('/v2/mr/radiologi/dokumen/$idPengantar',
        dokumenRadRequestModelToJson(dokumenRadRequestModel));
    return dokumenRadSaveModelFromJson(response);
  }

  Future<DokumenRadSaveModel> deleteDokumenRad(int idDokumen) async {
    final response =
        await dio.delete('/v2/mr/radiologi/dokumen-rad/$idDokumen');
    return dokumenRadSaveModelFromJson(response);
  }
}
