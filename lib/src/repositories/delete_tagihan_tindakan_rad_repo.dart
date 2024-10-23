import 'package:dokter_panggil/src/models/tagihan_tindakan_rad_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class DeleteTagihanTindakanRadRepo {
  Future<ResponseTagihanTindakanRadModel> deleteTagihanRad(int? id) async {
    final response = await dio.delete('/v1/tagihan-rad/tindakan-rad/$id');
    return responseTagihanTindakanRadModelFromJson(response);
  }
}
