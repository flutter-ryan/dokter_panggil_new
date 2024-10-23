import 'package:dokter_panggil/src/models/dokumen_pengantar_rad_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class DokumenPengantarRadRepo {
  Future<ResponseDokumenPengantarRadModel> getDokumenPengantarRad(
      DokumenPengantarRadModel dokumenPengantarRadModel) async {
    final response = await dio.post('/v1/layanan-kunjungan/pengantar-rad',
        dokumenPengantarRadModelToJson(dokumenPengantarRadModel));
    return responseDokumenPengantarRadModelFromJson(response);
  }

  Future<ResponseListTindakanRadPengantarModel> getListTindakanRadPengantar(
      DokumenPengantarRadModel dokumenPengantarRadModel) async {
    final response = await dio.post(
      '/v1/layanan-kunjungan/list-tindakan-pengantar-rad',
      dokumenPengantarRadModelToJson(dokumenPengantarRadModel),
    );
    return responseListTindakanRadPengantarModelFromJson(response);
  }
}
