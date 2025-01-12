import 'package:dokter_panggil/src/models/update_kunjungan_resep_tagihan_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class UpdateKunjunganResepRacikanTagihanRepo {
  Future<ResponseUpdateKunjunganResepTagihanModel> updateTagihanResepRacikan(
      int? idTagihanRacikan,
      UpdateKunjunganResepTagihanModel updateKunjunganResepTagihanModel) async {
    final response = await dio.put(
        '/v2/mr/resep-racikan/tagihan/$idTagihanRacikan',
        updateKunjunganResepTagihanModelToJson(
            updateKunjunganResepTagihanModel));
    return responseUpdateKunjunganResepTagihanModelFromJson(response);
  }
}
