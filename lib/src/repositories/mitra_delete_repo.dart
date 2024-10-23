import 'package:dokter_panggil/src/models/mitra_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MitraDeleteRepo {
  Future<ResponseMitraModel> deleteMitra(int? id) async {
    final response = await dio.delete('/v1/master/mitra/$id');
    return responseMitraModelFromJson(response);
  }
}
