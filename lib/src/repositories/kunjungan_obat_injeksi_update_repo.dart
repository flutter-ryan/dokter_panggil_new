import 'package:admin_dokter_panggil/src/models/kunjungan_obat_injeksi_update_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class KunjunganObatInjeksiUpdateRepo {
  Future<ResponseKunjunganObatInkjeksiUpdateModel> updateObatInjeksi(
      KunjunganObatInkjeksiUpdateModel kunjunganObatInkjeksiUpdateModel,
      int id) async {
    final response = await dio.put(
        '/v1/layanan-kunjungan/obat-injeksi/$id',
        kunjunganObatInkjeksiUpdateModelToJson(
            kunjunganObatInkjeksiUpdateModel));
    return responseKunjunganObatInkjeksiUpdateModelFromJson(response);
  }
}
