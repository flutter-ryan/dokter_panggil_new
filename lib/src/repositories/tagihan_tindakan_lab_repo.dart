import 'package:dokter_panggil/src/models/tagihan_tindakan_lab_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class TagihanTindakanLabRepo {
  Future<ResponseTagihanTindakanLabModel> saveTindakanLab(
      TagihanTindakanLabModel tagihanTindakanLabModel) async {
    final response = await dio.post('/v1/tagihan-lab/tindakan-lab',
        tagihanTindakanLabModelToJson(tagihanTindakanLabModel));
    return responseTagihanTindakanLabModelFromJson(response);
  }
}
