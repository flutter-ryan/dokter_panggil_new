import 'package:admin_dokter_panggil/src/models/tindakan_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class TindakanDeleteRepo {
  Future<ResponseTindakanModel> deleteTindakan(int? id) async {
    final response = await dio.delete('/v1/master/tindakan/$id');
    return responseTindakanModelFromJson(response);
  }
}
