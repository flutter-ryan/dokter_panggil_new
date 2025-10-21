import 'package:admin_dokter_panggil/src/models/tagihan_tindakan_lab_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class TagihanTindakanLabSaveRepo {
  Future<TagihanTindakanLabSaveModel> saveTagihanTindakanLab(
      TagihanTindakanLabRequestModel tagihanTindakanLabRequestModel,
      int idPengantar) async {
    final response = await dio.post('/v2/mr/laboratorium/tagihan/$idPengantar',
        tagihanTindakanLabRequestModelToJson(tagihanTindakanLabRequestModel));
    return tagihanTindakanLabSaveModelFromJson(response);
  }
}
