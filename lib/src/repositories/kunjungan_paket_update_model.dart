import 'package:dokter_panggil/src/models/kunjungan_paket_update_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class KunjunganPaketUpdateRepo {
  Future<ResponseKunjunganPaketUpdateModel> updateKunjunganPaket(
      KunjunganPaketUpdateModel kunjunganPaketUpdateModel,
      int idKunjungan) async {
    final response = await dio.put('/v2/mr/daftar-paket/$idKunjungan',
        kunjunganPaketUpdateModelToJson(kunjunganPaketUpdateModel));
    return responseKunjunganPaketUpdateModelFromJson(response);
  }

  Future<ResponseKunjunganPaketUpdateModel> storeKunjunganPaket(
      KunjunganPaketUpdateModel kunjunganPaketUpdateModel,
      int idKunjungan) async {
    final response = await dio.post('/v1/kunjungan/paket/$idKunjungan',
        kunjunganPaketUpdateModelToJson(kunjunganPaketUpdateModel));
    return responseKunjunganPaketUpdateModelFromJson(response);
  }
}
