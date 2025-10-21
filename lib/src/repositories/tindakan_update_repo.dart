import 'package:admin_dokter_panggil/src/models/tindakan_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class TindakanUpdateRepo {
  Future<ResponseTindakanModel> updateTindakan(
      int? id, TindakanModel tindakanModel) async {
    final response = await dio.put(
        '/v1/master/tindakan/$id', tindakanModelToJson(tindakanModel));
    return responseTindakanModelFromJson(response);
  }
}
