import 'package:dokter_panggil/src/models/kunjungan_racikan_update_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class KunjunganRacikanUpdateRepo {
  Future<ResponseKunjunganRacikanUpdateModel> updateRacikan(
      KunjunganRacikanUpdateModel kunjunganRacikanUpdateModel, int? id) async {
    final response = await dio.post('/v1/kunjungan/tagihan/racikan/$id',
        kunjunganRacikanUpdateModelToJson(kunjunganRacikanUpdateModel));
    return responseKunjunganRacikanUpdateModelFromJson(response);
  }
}
