import 'package:dokter_panggil/src/models/tindakan_save_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class TindakanSaveRepo {
  Future<ResponseTindakanModel> saveTindakan(
      TindakanModel tindakanModel) async {
    final response = await dio.post(
        '/v1/master/tindakan', tindakanModelToJson(tindakanModel));
    return responseTindakanModelFromJson(response);
  }
}
