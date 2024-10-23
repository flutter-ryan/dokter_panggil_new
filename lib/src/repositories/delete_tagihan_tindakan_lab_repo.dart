import 'package:dokter_panggil/src/models/tagihan_tindakan_lab_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class DeleteTagihanTindakanLabRepo {
  Future<ResponseTagihanTindakanLabModel> deleteTagihanTindakanLab(
      int id) async {
    final response = await dio.delete('/v1/tagihan-lab/tindakan-lab/$id');
    return responseTagihanTindakanLabModelFromJson(response);
  }
}
