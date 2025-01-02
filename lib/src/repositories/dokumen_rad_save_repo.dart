import 'package:dokter_panggil/src/models/dokumen_rad_save_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class DokumenRadSaveRepo {
  Future<DokumenRadSaveModel> uploadDokumenRad(
      DokumenRadRequestModel dokumenRadRequestModel, int idKunjungan) async {
    final response = await dio.post('/v2/mr/radiologi/dokumen-rad/$idKunjungan',
        dokumenRadRequestModelToJson(dokumenRadRequestModel));
    return dokumenRadSaveModelFromJson(response);
  }

  Future<DokumenRadSaveModel> deleteDokumenRad(int idDokumen) async {
    final response =
        await dio.delete('/v2/mr/radiologi/dokumen-rad/$idDokumen');
    return dokumenRadSaveModelFromJson(response);
  }
}
