import 'package:dokter_panggil/src/models/kunjungan_bhp_update_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class KunjunganBhpUpdateRepo {
  Future<ResponseKunjunganBhpUpdateModel> updateKunjunganBhp(
      KunjunganBhpUpdateModel kunjunganBhpUpdateModel, int id) async {
    final response = await dio.put('/v1/kunjungan/kunjungan-bhp/update/$id',
        kunjunganBhpUpdateModelToJson(kunjunganBhpUpdateModel));
    return responseKunjunganBhpUpdateModelFromJson(response);
  }
}
