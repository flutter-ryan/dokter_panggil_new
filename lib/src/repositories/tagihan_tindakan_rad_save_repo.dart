import 'package:admin_dokter_panggil/src/models/tagihan_tindakan_rad_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class TagihanTindakanRadSaveRepo {
  Future<TagihanTindakanRadSaveModel> simpanTindakanRad(
      TagihanTindakanRadRequestModel tagihanTindakanRadRequestModel,
      int idPengantar) async {
    final response = await dio.post('/v2/mr/radiologi/tagihan/$idPengantar',
        tagihanTindakanRadRequestModelToJson(tagihanTindakanRadRequestModel));
    return tagihanTindakanRadSaveModelFromJson(response);
  }
}
