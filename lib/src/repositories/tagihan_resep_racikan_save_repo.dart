import 'package:admin_dokter_panggil/src/models/tagihan_resep_racikan_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class TagihanResepRacikanSaveRepo {
  Future<TagihanResepRacikanSaveModel> saveTagihanRacikan(
      TagihanResepRacikanRequestModel tagihanResepRacikanRequestModel,
      int idResepRacikan) async {
    final response = await dio.post(
        '/v2/mr/resep-racikan/tagihan/$idResepRacikan',
        tagihanResepRacikanRequestModelToJson(tagihanResepRacikanRequestModel));
    return tagihanResepRacikanSaveModelFromJson(response);
  }
}
