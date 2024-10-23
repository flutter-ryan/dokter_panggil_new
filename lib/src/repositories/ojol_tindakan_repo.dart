import 'package:dokter_panggil/src/models/ojol_tindakan_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class OjolTindakanRepo {
  Future<ResponseOjolTindakanModel> saveOjolTindakan(
      OjolTindakanModel ojolTindakanModel, int id) async {
    final response = await dio.post(
      '/v1/kunjungan/ojol/tindakan/$id',
      ojolTindakanModelToJson(ojolTindakanModel),
    );
    return responseOjolTindakanModelFromJson(response);
  }
}
