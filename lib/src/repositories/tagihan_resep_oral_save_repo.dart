import 'package:admin_dokter_panggil/src/models/tagihan_resep_oral_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class TagihanResepOralSaveRepo {
  Future<TagihanResepOralSaveModel> saveTagihanResepOral(
      TagihanResepOralRequestModel tagihanResepOralRequestModel,
      int idResepOral) async {
    final response = await dio.post('/v2/mr/resep-oral/tagihan/$idResepOral',
        tagihanResepOralRequestModelToJson(tagihanResepOralRequestModel));
    return tagihanResepOralSaveModelFromJson(response);
  }
}
