import 'package:admin_dokter_panggil/src/models/tagihan_tindakan_rad_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class TagihanTindakanRadRepo {
  Future<ResponseTagihanTindakanRadModel> saveTindakanRad(
      TagihanTindakanRadModel tagihanTindakanRadModel) async {
    final response = await dio.post('/v1/tagihan-rad/tindakan-rad',
        tagihanTindakanRadModelToJson(tagihanTindakanRadModel));
    return responseTagihanTindakanRadModelFromJson(response);
  }
}
