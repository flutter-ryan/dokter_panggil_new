import 'package:dokter_panggil/src/models/dokumen_pengantar_lab_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class DokumenPengantarLabRepo {
  Future<ResponseDokumenPengantarLabModel> getDokumenPengantarLab(
      DokumenPengantarLabModel dokumenPengantarLabModel) async {
    final response = await dio.post('/v1/layanan-kunjungan/pengantar-lab',
        dokumenPengantarLabModelToJson(dokumenPengantarLabModel));
    return responseDokumenPengantarLabModelFromJson(response);
  }

  Future<ResponseListTindakanLabPengantarModel> getListTindakanLabPengantar(
      DokumenPengantarLabModel dokumenPengantarLabModel) async {
    final response = await dio.post(
        '/v1/layanan-kunjungan/list-tindakan-pengantar-lab',
        dokumenPengantarLabModelToJson(dokumenPengantarLabModel));
    return responseListTindakanLabPengantarModelFromJson(response);
  }
}
